import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

def inspect_and_clean_prices():
    print("جاري الاتصال وسحب البيانات من السيرفر...")
    
    # تأكد أن اسم الكولكشن هنا يطابق ما هو موجود في فايربيس لديك تماماً
    collection_ref = db.collection('prices_catalog')
    docs = list(collection_ref.stream()) # تحويلها لقائمة لمعرفة العدد الإجمالي
    
    print(f"تم سحب {len(docs)} تسعيرة من قاعدة البيانات.")

    if len(docs) == 0:
        print("السبب: لم يتم العثور على أي بيانات. تأكد من اسم الـ Collection في الكود وفي فايربيس.")
        return

    # طباعة أول مستند للتأكد من مطابقة أسماء الحقول
    print("\n--- هيكل البيانات في أول مستند تم سحبه ---")
    print(docs[0].to_dict())
    print("-------------------------------------------\n")

    unique_keys = set()
    batch = db.batch()
    delete_count = 0
    total_deleted = 0

    for doc in docs:
        data = doc.to_dict()
        
        # استخراج القيم، تحويلها لنصوص، إزالة المسافات الزائدة، وتحويلها لأحرف كبيرة لتوحيد المقارنة
        device_model = str(data.get('deviceModel', '')).strip().upper()
        part_quality = str(data.get('partQuality', '')).strip().upper()
        
        # التأكد من التعامل مع السعر كرقم موحد (مثلا 70.0 هي نفسها 70)
        try:
            price = float(data.get('price', 0))
        except ValueError:
            price = 0.0
            
        supplier_name = str(data.get('supplierName', '')).strip().upper()

        # بناء المفتاح: نعتبر القطعة مكررة إذا تطابق الموديل والجودة والسعر والمورد
        # إذا أردت حذف المكرر حتى لو اختلف المورد، قم بإزالة {supplier_name} من السطر التالي
        key = f"{device_model}_{part_quality}_{price}_{supplier_name}"

        if key in unique_keys:
            batch.delete(doc.reference)
            delete_count += 1
            total_deleted += 1

            if delete_count >= 450:
                batch.commit()
                print(f"تم تنفيذ دفعة حذف... الإجمالي المحذوف حتى الآن: {total_deleted}")
                batch = db.batch()
                delete_count = 0
        else:
            unique_keys.add(key)

    if delete_count > 0:
        batch.commit()

    print(f"اكتملت عملية التنظيف.")
    print(f"إجمالي النسخ المكررة التي تم حذفها نهائياً: {total_deleted}")

if __name__ == "__main__":
    inspect_and_clean_prices()