import firebase_admin
from firebase_admin import credentials, firestore
import json

# 1. تهيئة الاتصال بـ Firebase
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# اسم المجموعة (Collection) في Firestore
collection_name = "prices_catalog"

def upload_data():
    # 2. قراءة ملف الـ JSON
    try:
        with open('all_prices.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"خطأ في قراءة ملف JSON: {e}")
        return

    # 3. الرفع بنظام الدفعات (Batch) لضمان السرعة والكفاءة
    batch = db.batch()
    count = 0
    total = len(data)

    print(f"بدء رفع {total} سجل إلى Firestore...")

    for item in data:
        doc_ref = db.collection(collection_name).document() # إنشاء وثيقة بهوية عشوائية
        batch.set(doc_ref, item)
        count += 1

        # Firestore يسمح بـ 500 عملية في الدفعة الواحدة فقط
        if count % 500 == 0:
            batch.commit()
            print(f"تم رفع {count} من أصل {total}...")
            batch = db.batch()

    # رفع السجلات المتبقية
    if count % 500 != 0:
        batch.commit()
    
    print(f"✅ تمت العملية بنجاح! تم رفع إجمالي {count} سجل.")

if __name__ == "__main__":
    upload_data()