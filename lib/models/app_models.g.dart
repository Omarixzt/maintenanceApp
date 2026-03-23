// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMaintenanceTicketCollection on Isar {
  IsarCollection<MaintenanceTicket> get maintenanceTickets => this.collection();
}

const MaintenanceTicketSchema = CollectionSchema(
  name: r'MaintenanceTicket',
  id: 8262080799585720985,
  properties: {
    r'customerName': PropertySchema(
      id: 0,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'deviceModel': PropertySchema(
      id: 1,
      name: r'deviceModel',
      type: IsarType.string,
    ),
    r'deviceType': PropertySchema(
      id: 2,
      name: r'deviceType',
      type: IsarType.string,
    ),
    r'expectedCost': PropertySchema(
      id: 3,
      name: r'expectedCost',
      type: IsarType.double,
    ),
    r'expectedDeliveryDate': PropertySchema(
      id: 4,
      name: r'expectedDeliveryDate',
      type: IsarType.string,
    ),
    r'faultDescription': PropertySchema(
      id: 5,
      name: r'faultDescription',
      type: IsarType.string,
    ),
    r'finalCost': PropertySchema(
      id: 6,
      name: r'finalCost',
      type: IsarType.double,
    ),
    r'firebaseId': PropertySchema(
      id: 7,
      name: r'firebaseId',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 8,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'imagePathAfter': PropertySchema(
      id: 9,
      name: r'imagePathAfter',
      type: IsarType.string,
    ),
    r'imei': PropertySchema(
      id: 10,
      name: r'imei',
      type: IsarType.string,
    ),
    r'isArchived': PropertySchema(
      id: 11,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'netProfit': PropertySchema(
      id: 12,
      name: r'netProfit',
      type: IsarType.double,
    ),
    r'phoneNumber': PropertySchema(
      id: 13,
      name: r'phoneNumber',
      type: IsarType.string,
    ),
    r'receivedDate': PropertySchema(
      id: 14,
      name: r'receivedDate',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 15,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 16,
      name: r'status',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 17,
      name: r'syncStatus',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 18,
      name: r'updatedAt',
      type: IsarType.long,
    )
  },
  estimateSize: _maintenanceTicketEstimateSize,
  serialize: _maintenanceTicketSerialize,
  deserialize: _maintenanceTicketDeserialize,
  deserializeProp: _maintenanceTicketDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'firebaseId': IndexSchema(
      id: -334079192014120732,
      name: r'firebaseId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'firebaseId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'shopId': IndexSchema(
      id: 4502922094527709227,
      name: r'shopId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'shopId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _maintenanceTicketGetId,
  getLinks: _maintenanceTicketGetLinks,
  attach: _maintenanceTicketAttach,
  version: '3.1.0+1',
);

int _maintenanceTicketEstimateSize(
  MaintenanceTicket object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customerName.length * 3;
  bytesCount += 3 + object.deviceModel.length * 3;
  bytesCount += 3 + object.deviceType.length * 3;
  {
    final value = object.expectedDeliveryDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.faultDescription.length * 3;
  {
    final value = object.firebaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.imagePathAfter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.imei.length * 3;
  bytesCount += 3 + object.phoneNumber.length * 3;
  bytesCount += 3 + object.receivedDate.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _maintenanceTicketSerialize(
  MaintenanceTicket object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.customerName);
  writer.writeString(offsets[1], object.deviceModel);
  writer.writeString(offsets[2], object.deviceType);
  writer.writeDouble(offsets[3], object.expectedCost);
  writer.writeString(offsets[4], object.expectedDeliveryDate);
  writer.writeString(offsets[5], object.faultDescription);
  writer.writeDouble(offsets[6], object.finalCost);
  writer.writeString(offsets[7], object.firebaseId);
  writer.writeString(offsets[8], object.imagePath);
  writer.writeString(offsets[9], object.imagePathAfter);
  writer.writeString(offsets[10], object.imei);
  writer.writeBool(offsets[11], object.isArchived);
  writer.writeDouble(offsets[12], object.netProfit);
  writer.writeString(offsets[13], object.phoneNumber);
  writer.writeString(offsets[14], object.receivedDate);
  writer.writeString(offsets[15], object.shopId);
  writer.writeString(offsets[16], object.status);
  writer.writeLong(offsets[17], object.syncStatus);
  writer.writeLong(offsets[18], object.updatedAt);
}

MaintenanceTicket _maintenanceTicketDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MaintenanceTicket();
  object.customerName = reader.readString(offsets[0]);
  object.deviceModel = reader.readString(offsets[1]);
  object.deviceType = reader.readString(offsets[2]);
  object.expectedCost = reader.readDouble(offsets[3]);
  object.expectedDeliveryDate = reader.readStringOrNull(offsets[4]);
  object.faultDescription = reader.readString(offsets[5]);
  object.finalCost = reader.readDouble(offsets[6]);
  object.firebaseId = reader.readStringOrNull(offsets[7]);
  object.imagePath = reader.readStringOrNull(offsets[8]);
  object.imagePathAfter = reader.readStringOrNull(offsets[9]);
  object.imei = reader.readString(offsets[10]);
  object.isArchived = reader.readBool(offsets[11]);
  object.isarId = id;
  object.netProfit = reader.readDouble(offsets[12]);
  object.phoneNumber = reader.readString(offsets[13]);
  object.receivedDate = reader.readString(offsets[14]);
  object.shopId = reader.readString(offsets[15]);
  object.status = reader.readString(offsets[16]);
  object.syncStatus = reader.readLong(offsets[17]);
  object.updatedAt = reader.readLong(offsets[18]);
  return object;
}

P _maintenanceTicketDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _maintenanceTicketGetId(MaintenanceTicket object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _maintenanceTicketGetLinks(
    MaintenanceTicket object) {
  return [];
}

void _maintenanceTicketAttach(
    IsarCollection<dynamic> col, Id id, MaintenanceTicket object) {
  object.isarId = id;
}

extension MaintenanceTicketByIndex on IsarCollection<MaintenanceTicket> {
  Future<MaintenanceTicket?> getByFirebaseId(String? firebaseId) {
    return getByIndex(r'firebaseId', [firebaseId]);
  }

  MaintenanceTicket? getByFirebaseIdSync(String? firebaseId) {
    return getByIndexSync(r'firebaseId', [firebaseId]);
  }

  Future<bool> deleteByFirebaseId(String? firebaseId) {
    return deleteByIndex(r'firebaseId', [firebaseId]);
  }

  bool deleteByFirebaseIdSync(String? firebaseId) {
    return deleteByIndexSync(r'firebaseId', [firebaseId]);
  }

  Future<List<MaintenanceTicket?>> getAllByFirebaseId(
      List<String?> firebaseIdValues) {
    final values = firebaseIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'firebaseId', values);
  }

  List<MaintenanceTicket?> getAllByFirebaseIdSync(
      List<String?> firebaseIdValues) {
    final values = firebaseIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'firebaseId', values);
  }

  Future<int> deleteAllByFirebaseId(List<String?> firebaseIdValues) {
    final values = firebaseIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'firebaseId', values);
  }

  int deleteAllByFirebaseIdSync(List<String?> firebaseIdValues) {
    final values = firebaseIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'firebaseId', values);
  }

  Future<Id> putByFirebaseId(MaintenanceTicket object) {
    return putByIndex(r'firebaseId', object);
  }

  Id putByFirebaseIdSync(MaintenanceTicket object, {bool saveLinks = true}) {
    return putByIndexSync(r'firebaseId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFirebaseId(List<MaintenanceTicket> objects) {
    return putAllByIndex(r'firebaseId', objects);
  }

  List<Id> putAllByFirebaseIdSync(List<MaintenanceTicket> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'firebaseId', objects, saveLinks: saveLinks);
  }
}

extension MaintenanceTicketQueryWhereSort
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QWhere> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MaintenanceTicketQueryWhere
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QWhereClause> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      firebaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'firebaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      firebaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'firebaseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      firebaseIdEqualTo(String? firebaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'firebaseId',
        value: [firebaseId],
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      firebaseIdNotEqualTo(String? firebaseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firebaseId',
              lower: [],
              upper: [firebaseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firebaseId',
              lower: [firebaseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firebaseId',
              lower: [firebaseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'firebaseId',
              lower: [],
              upper: [firebaseId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterWhereClause>
      shopIdNotEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MaintenanceTicketQueryFilter
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QFilterCondition> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceType',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      deviceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceType',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedCostEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedCostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedCostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedCostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expectedDeliveryDate',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expectedDeliveryDate',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedDeliveryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expectedDeliveryDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expectedDeliveryDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedDeliveryDate',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      expectedDeliveryDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expectedDeliveryDate',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'faultDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'faultDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'faultDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'faultDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      faultDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'faultDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      finalCostEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      finalCostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      finalCostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalCost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      finalCostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalCost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firebaseId',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'firebaseId',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firebaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firebaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firebaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firebaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      firebaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firebaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePathAfter',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePathAfter',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePathAfter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePathAfter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePathAfter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePathAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imagePathAfterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePathAfter',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imei',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imei',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imei',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imei',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      imeiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imei',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isArchived',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      netProfitEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'netProfit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      netProfitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'netProfit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      netProfitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'netProfit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      netProfitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'netProfit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phoneNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phoneNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receivedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receivedDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receivedDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivedDate',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      receivedDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receivedDate',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      syncStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      syncStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      syncStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      syncStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      updatedAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      updatedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      updatedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterFilterCondition>
      updatedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MaintenanceTicketQueryObject
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QFilterCondition> {}

extension MaintenanceTicketQueryLinks
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QFilterCondition> {}

extension MaintenanceTicketQuerySortBy
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QSortBy> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByDeviceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceType', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByDeviceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceType', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByExpectedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCost', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByExpectedCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCost', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByExpectedDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDeliveryDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByExpectedDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDeliveryDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFaultDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faultDescription', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFaultDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faultDescription', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFinalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCost', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFinalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCost', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFirebaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firebaseId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByFirebaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firebaseId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImagePathAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePathAfter', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImagePathAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePathAfter', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImei() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imei', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByImeiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imei', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByNetProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netProfit', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByNetProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netProfit', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByReceivedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByReceivedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MaintenanceTicketQuerySortThenBy
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QSortThenBy> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByDeviceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceType', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByDeviceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceType', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByExpectedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCost', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByExpectedCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCost', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByExpectedDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDeliveryDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByExpectedDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDeliveryDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFaultDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faultDescription', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFaultDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'faultDescription', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFinalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCost', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFinalCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCost', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFirebaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firebaseId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByFirebaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firebaseId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImagePathAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePathAfter', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImagePathAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePathAfter', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImei() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imei', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByImeiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imei', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByNetProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netProfit', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByNetProfitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'netProfit', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByReceivedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedDate', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByReceivedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivedDate', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MaintenanceTicketQueryWhereDistinct
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct> {
  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByCustomerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByDeviceModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByDeviceType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByExpectedCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedCost');
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByExpectedDeliveryDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedDeliveryDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByFaultDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'faultDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByFinalCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalCost');
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByFirebaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firebaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByImagePathAfter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePathAfter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct> distinctByImei(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imei', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByNetProfit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'netProfit');
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByPhoneNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phoneNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByReceivedDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivedDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<MaintenanceTicket, MaintenanceTicket, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MaintenanceTicketQueryProperty
    on QueryBuilder<MaintenanceTicket, MaintenanceTicket, QQueryProperty> {
  QueryBuilder<MaintenanceTicket, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      deviceModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceModel');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      deviceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceType');
    });
  }

  QueryBuilder<MaintenanceTicket, double, QQueryOperations>
      expectedCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedCost');
    });
  }

  QueryBuilder<MaintenanceTicket, String?, QQueryOperations>
      expectedDeliveryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedDeliveryDate');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      faultDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'faultDescription');
    });
  }

  QueryBuilder<MaintenanceTicket, double, QQueryOperations>
      finalCostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalCost');
    });
  }

  QueryBuilder<MaintenanceTicket, String?, QQueryOperations>
      firebaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firebaseId');
    });
  }

  QueryBuilder<MaintenanceTicket, String?, QQueryOperations>
      imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<MaintenanceTicket, String?, QQueryOperations>
      imagePathAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePathAfter');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations> imeiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imei');
    });
  }

  QueryBuilder<MaintenanceTicket, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<MaintenanceTicket, double, QQueryOperations>
      netProfitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'netProfit');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phoneNumber');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations>
      receivedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivedDate');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations> shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<MaintenanceTicket, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<MaintenanceTicket, int, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<MaintenanceTicket, int, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalPartCollection on Isar {
  IsarCollection<LocalPart> get localParts => this.collection();
}

const LocalPartSchema = CollectionSchema(
  name: r'LocalPart',
  id: 4578532241314647010,
  properties: {
    r'costPrice': PropertySchema(
      id: 0,
      name: r'costPrice',
      type: IsarType.double,
    ),
    r'deviceBrand': PropertySchema(
      id: 1,
      name: r'deviceBrand',
      type: IsarType.string,
    ),
    r'deviceModel': PropertySchema(
      id: 2,
      name: r'deviceModel',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 3,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'partId': PropertySchema(
      id: 4,
      name: r'partId',
      type: IsarType.string,
    ),
    r'partName': PropertySchema(
      id: 5,
      name: r'partName',
      type: IsarType.string,
    ),
    r'partType': PropertySchema(
      id: 6,
      name: r'partType',
      type: IsarType.string,
    ),
    r'quantity': PropertySchema(
      id: 7,
      name: r'quantity',
      type: IsarType.long,
    ),
    r'shopId': PropertySchema(
      id: 8,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.long,
    )
  },
  estimateSize: _localPartEstimateSize,
  serialize: _localPartSerialize,
  deserialize: _localPartDeserialize,
  deserializeProp: _localPartDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'partId': IndexSchema(
      id: 706765669750824708,
      name: r'partId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'partId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'shopId': IndexSchema(
      id: 4502922094527709227,
      name: r'shopId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'shopId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localPartGetId,
  getLinks: _localPartGetLinks,
  attach: _localPartAttach,
  version: '3.1.0+1',
);

int _localPartEstimateSize(
  LocalPart object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceBrand.length * 3;
  bytesCount += 3 + object.deviceModel.length * 3;
  {
    final value = object.partId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.partName.length * 3;
  bytesCount += 3 + object.partType.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  return bytesCount;
}

void _localPartSerialize(
  LocalPart object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.costPrice);
  writer.writeString(offsets[1], object.deviceBrand);
  writer.writeString(offsets[2], object.deviceModel);
  writer.writeBool(offsets[3], object.isDeleted);
  writer.writeString(offsets[4], object.partId);
  writer.writeString(offsets[5], object.partName);
  writer.writeString(offsets[6], object.partType);
  writer.writeLong(offsets[7], object.quantity);
  writer.writeString(offsets[8], object.shopId);
  writer.writeLong(offsets[9], object.syncStatus);
  writer.writeLong(offsets[10], object.updatedAt);
}

LocalPart _localPartDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalPart();
  object.costPrice = reader.readDouble(offsets[0]);
  object.deviceBrand = reader.readString(offsets[1]);
  object.deviceModel = reader.readString(offsets[2]);
  object.isDeleted = reader.readBool(offsets[3]);
  object.isarId = id;
  object.partId = reader.readStringOrNull(offsets[4]);
  object.partName = reader.readString(offsets[5]);
  object.partType = reader.readString(offsets[6]);
  object.quantity = reader.readLong(offsets[7]);
  object.shopId = reader.readString(offsets[8]);
  object.syncStatus = reader.readLong(offsets[9]);
  object.updatedAt = reader.readLong(offsets[10]);
  return object;
}

P _localPartDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localPartGetId(LocalPart object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _localPartGetLinks(LocalPart object) {
  return [];
}

void _localPartAttach(IsarCollection<dynamic> col, Id id, LocalPart object) {
  object.isarId = id;
}

extension LocalPartByIndex on IsarCollection<LocalPart> {
  Future<LocalPart?> getByPartId(String? partId) {
    return getByIndex(r'partId', [partId]);
  }

  LocalPart? getByPartIdSync(String? partId) {
    return getByIndexSync(r'partId', [partId]);
  }

  Future<bool> deleteByPartId(String? partId) {
    return deleteByIndex(r'partId', [partId]);
  }

  bool deleteByPartIdSync(String? partId) {
    return deleteByIndexSync(r'partId', [partId]);
  }

  Future<List<LocalPart?>> getAllByPartId(List<String?> partIdValues) {
    final values = partIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'partId', values);
  }

  List<LocalPart?> getAllByPartIdSync(List<String?> partIdValues) {
    final values = partIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'partId', values);
  }

  Future<int> deleteAllByPartId(List<String?> partIdValues) {
    final values = partIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'partId', values);
  }

  int deleteAllByPartIdSync(List<String?> partIdValues) {
    final values = partIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'partId', values);
  }

  Future<Id> putByPartId(LocalPart object) {
    return putByIndex(r'partId', object);
  }

  Id putByPartIdSync(LocalPart object, {bool saveLinks = true}) {
    return putByIndexSync(r'partId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPartId(List<LocalPart> objects) {
    return putAllByIndex(r'partId', objects);
  }

  List<Id> putAllByPartIdSync(List<LocalPart> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'partId', objects, saveLinks: saveLinks);
  }
}

extension LocalPartQueryWhereSort
    on QueryBuilder<LocalPart, LocalPart, QWhere> {
  QueryBuilder<LocalPart, LocalPart, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension LocalPartQueryWhere
    on QueryBuilder<LocalPart, LocalPart, QWhereClause> {
  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> partIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'partId',
        value: [null],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> partIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'partId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> partIdEqualTo(
      String? partId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'partId',
        value: [partId],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> partIdNotEqualTo(
      String? partId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'partId',
              lower: [],
              upper: [partId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'partId',
              lower: [partId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'partId',
              lower: [partId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'partId',
              lower: [],
              upper: [partId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> shopIdEqualTo(
      String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> shopIdNotEqualTo(
      String shopId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> updatedAtEqualTo(
      int updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> updatedAtNotEqualTo(
      int updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> updatedAtGreaterThan(
    int updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> updatedAtLessThan(
    int updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterWhereClause> updatedAtBetween(
    int lowerUpdatedAt,
    int upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalPartQueryFilter
    on QueryBuilder<LocalPart, LocalPart, QFilterCondition> {
  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> costPriceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'costPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      costPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'costPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> costPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'costPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> costPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'costPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceBrandGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceBrand',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceBrandStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceBrandMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceBrand',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceBrandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceBrand',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceBrandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceBrand',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> deviceModelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      deviceModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> isDeletedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partId',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partId',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      partNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> partTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      partTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> quantityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> quantityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> quantityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantity',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> syncStatusEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      syncStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> syncStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> syncStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> updatedAtEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition>
      updatedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> updatedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterFilterCondition> updatedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalPartQueryObject
    on QueryBuilder<LocalPart, LocalPart, QFilterCondition> {}

extension LocalPartQueryLinks
    on QueryBuilder<LocalPart, LocalPart, QFilterCondition> {}

extension LocalPartQuerySortBy on QueryBuilder<LocalPart, LocalPart, QSortBy> {
  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByCostPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPrice', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByCostPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPrice', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByDeviceBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByDeviceBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partId', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partId', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partName', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partName', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partType', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByPartTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partType', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalPartQuerySortThenBy
    on QueryBuilder<LocalPart, LocalPart, QSortThenBy> {
  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByCostPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPrice', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByCostPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costPrice', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByDeviceBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByDeviceBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partId', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partId', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partName', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partName', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partType', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByPartTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partType', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantity', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalPartQueryWhereDistinct
    on QueryBuilder<LocalPart, LocalPart, QDistinct> {
  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByCostPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'costPrice');
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByDeviceBrand(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceBrand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByDeviceModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByPartId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByPartName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByPartType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantity');
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByShopId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<LocalPart, LocalPart, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalPartQueryProperty
    on QueryBuilder<LocalPart, LocalPart, QQueryProperty> {
  QueryBuilder<LocalPart, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalPart, double, QQueryOperations> costPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'costPrice');
    });
  }

  QueryBuilder<LocalPart, String, QQueryOperations> deviceBrandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceBrand');
    });
  }

  QueryBuilder<LocalPart, String, QQueryOperations> deviceModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceModel');
    });
  }

  QueryBuilder<LocalPart, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<LocalPart, String?, QQueryOperations> partIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partId');
    });
  }

  QueryBuilder<LocalPart, String, QQueryOperations> partNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partName');
    });
  }

  QueryBuilder<LocalPart, String, QQueryOperations> partTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partType');
    });
  }

  QueryBuilder<LocalPart, int, QQueryOperations> quantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantity');
    });
  }

  QueryBuilder<LocalPart, String, QQueryOperations> shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<LocalPart, int, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<LocalPart, int, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingCollection on Isar {
  IsarCollection<AppSetting> get appSettings => this.collection();
}

const AppSettingSchema = CollectionSchema(
  name: r'AppSetting',
  id: -948817443998796339,
  properties: {
    r'key': PropertySchema(
      id: 0,
      name: r'key',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _appSettingEstimateSize,
  serialize: _appSettingSerialize,
  deserialize: _appSettingDeserialize,
  deserializeProp: _appSettingDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appSettingGetId,
  getLinks: _appSettingGetLinks,
  attach: _appSettingAttach,
  version: '3.1.0+1',
);

int _appSettingEstimateSize(
  AppSetting object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appSettingSerialize(
  AppSetting object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeString(offsets[1], object.value);
}

AppSetting _appSettingDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSetting();
  object.isarId = id;
  object.key = reader.readStringOrNull(offsets[0]);
  object.value = reader.readStringOrNull(offsets[1]);
  return object;
}

P _appSettingDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingGetId(AppSetting object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _appSettingGetLinks(AppSetting object) {
  return [];
}

void _appSettingAttach(IsarCollection<dynamic> col, Id id, AppSetting object) {
  object.isarId = id;
}

extension AppSettingByIndex on IsarCollection<AppSetting> {
  Future<AppSetting?> getByKey(String? key) {
    return getByIndex(r'key', [key]);
  }

  AppSetting? getByKeySync(String? key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String? key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String? key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AppSetting?>> getAllByKey(List<String?> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AppSetting?> getAllByKeySync(List<String?> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String?> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String?> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(AppSetting object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AppSetting object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AppSetting> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AppSetting> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AppSettingQueryWhereSort
    on QueryBuilder<AppSetting, AppSetting, QWhere> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingQueryWhere
    on QueryBuilder<AppSetting, AppSetting, QWhereClause> {
  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [null],
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'key',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyEqualTo(
      String? key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterWhereClause> keyNotEqualTo(
      String? key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppSettingQueryFilter
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {
  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension AppSettingQueryObject
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQueryLinks
    on QueryBuilder<AppSetting, AppSetting, QFilterCondition> {}

extension AppSettingQuerySortBy
    on QueryBuilder<AppSetting, AppSetting, QSortBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension AppSettingQuerySortThenBy
    on QueryBuilder<AppSetting, AppSetting, QSortThenBy> {
  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension AppSettingQueryWhereDistinct
    on QueryBuilder<AppSetting, AppSetting, QDistinct> {
  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSetting, AppSetting, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingQueryProperty
    on QueryBuilder<AppSetting, AppSetting, QQueryProperty> {
  QueryBuilder<AppSetting, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AppSetting, String?, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AppSetting, String?, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDeviceBrandCollection on Isar {
  IsarCollection<DeviceBrand> get deviceBrands => this.collection();
}

const DeviceBrandSchema = CollectionSchema(
  name: r'DeviceBrand',
  id: -7596052188258654561,
  properties: {
    r'models': PropertySchema(
      id: 0,
      name: r'models',
      type: IsarType.stringList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _deviceBrandEstimateSize,
  serialize: _deviceBrandSerialize,
  deserialize: _deviceBrandDeserialize,
  deserializeProp: _deviceBrandDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _deviceBrandGetId,
  getLinks: _deviceBrandGetLinks,
  attach: _deviceBrandAttach,
  version: '3.1.0+1',
);

int _deviceBrandEstimateSize(
  DeviceBrand object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.models.length * 3;
  {
    for (var i = 0; i < object.models.length; i++) {
      final value = object.models[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _deviceBrandSerialize(
  DeviceBrand object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.models);
  writer.writeString(offsets[1], object.name);
}

DeviceBrand _deviceBrandDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DeviceBrand();
  object.isarId = id;
  object.models = reader.readStringList(offsets[0]) ?? [];
  object.name = reader.readString(offsets[1]);
  return object;
}

P _deviceBrandDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _deviceBrandGetId(DeviceBrand object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _deviceBrandGetLinks(DeviceBrand object) {
  return [];
}

void _deviceBrandAttach(
    IsarCollection<dynamic> col, Id id, DeviceBrand object) {
  object.isarId = id;
}

extension DeviceBrandByIndex on IsarCollection<DeviceBrand> {
  Future<DeviceBrand?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  DeviceBrand? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<DeviceBrand?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<DeviceBrand?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(DeviceBrand object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(DeviceBrand object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<DeviceBrand> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<DeviceBrand> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension DeviceBrandQueryWhereSort
    on QueryBuilder<DeviceBrand, DeviceBrand, QWhere> {
  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DeviceBrandQueryWhere
    on QueryBuilder<DeviceBrand, DeviceBrand, QWhereClause> {
  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DeviceBrandQueryFilter
    on QueryBuilder<DeviceBrand, DeviceBrand, QFilterCondition> {
  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'models',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'models',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'models',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'models',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'models',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      modelsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'models',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension DeviceBrandQueryObject
    on QueryBuilder<DeviceBrand, DeviceBrand, QFilterCondition> {}

extension DeviceBrandQueryLinks
    on QueryBuilder<DeviceBrand, DeviceBrand, QFilterCondition> {}

extension DeviceBrandQuerySortBy
    on QueryBuilder<DeviceBrand, DeviceBrand, QSortBy> {
  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension DeviceBrandQuerySortThenBy
    on QueryBuilder<DeviceBrand, DeviceBrand, QSortThenBy> {
  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension DeviceBrandQueryWhereDistinct
    on QueryBuilder<DeviceBrand, DeviceBrand, QDistinct> {
  QueryBuilder<DeviceBrand, DeviceBrand, QDistinct> distinctByModels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'models');
    });
  }

  QueryBuilder<DeviceBrand, DeviceBrand, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension DeviceBrandQueryProperty
    on QueryBuilder<DeviceBrand, DeviceBrand, QQueryProperty> {
  QueryBuilder<DeviceBrand, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DeviceBrand, List<String>, QQueryOperations> modelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'models');
    });
  }

  QueryBuilder<DeviceBrand, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuickPriceCollection on Isar {
  IsarCollection<QuickPrice> get quickPrices => this.collection();
}

const QuickPriceSchema = CollectionSchema(
  name: r'QuickPrice',
  id: 5020277613705609682,
  properties: {
    r'indexId': PropertySchema(
      id: 0,
      name: r'indexId',
      type: IsarType.long,
    ),
    r'price': PropertySchema(
      id: 1,
      name: r'price',
      type: IsarType.double,
    )
  },
  estimateSize: _quickPriceEstimateSize,
  serialize: _quickPriceSerialize,
  deserialize: _quickPriceDeserialize,
  deserializeProp: _quickPriceDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _quickPriceGetId,
  getLinks: _quickPriceGetLinks,
  attach: _quickPriceAttach,
  version: '3.1.0+1',
);

int _quickPriceEstimateSize(
  QuickPrice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _quickPriceSerialize(
  QuickPrice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.indexId);
  writer.writeDouble(offsets[1], object.price);
}

QuickPrice _quickPriceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuickPrice();
  object.indexId = reader.readLong(offsets[0]);
  object.isarId = id;
  object.price = reader.readDouble(offsets[1]);
  return object;
}

P _quickPriceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quickPriceGetId(QuickPrice object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _quickPriceGetLinks(QuickPrice object) {
  return [];
}

void _quickPriceAttach(IsarCollection<dynamic> col, Id id, QuickPrice object) {
  object.isarId = id;
}

extension QuickPriceQueryWhereSort
    on QueryBuilder<QuickPrice, QuickPrice, QWhere> {
  QueryBuilder<QuickPrice, QuickPrice, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuickPriceQueryWhere
    on QueryBuilder<QuickPrice, QuickPrice, QWhereClause> {
  QueryBuilder<QuickPrice, QuickPrice, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension QuickPriceQueryFilter
    on QueryBuilder<QuickPrice, QuickPrice, QFilterCondition> {
  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> indexIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'indexId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition>
      indexIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'indexId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> indexIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'indexId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> indexIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'indexId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterFilterCondition> priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension QuickPriceQueryObject
    on QueryBuilder<QuickPrice, QuickPrice, QFilterCondition> {}

extension QuickPriceQueryLinks
    on QueryBuilder<QuickPrice, QuickPrice, QFilterCondition> {}

extension QuickPriceQuerySortBy
    on QueryBuilder<QuickPrice, QuickPrice, QSortBy> {
  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> sortByIndexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexId', Sort.asc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> sortByIndexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexId', Sort.desc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }
}

extension QuickPriceQuerySortThenBy
    on QueryBuilder<QuickPrice, QuickPrice, QSortThenBy> {
  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByIndexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexId', Sort.asc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByIndexIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'indexId', Sort.desc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }
}

extension QuickPriceQueryWhereDistinct
    on QueryBuilder<QuickPrice, QuickPrice, QDistinct> {
  QueryBuilder<QuickPrice, QuickPrice, QDistinct> distinctByIndexId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'indexId');
    });
  }

  QueryBuilder<QuickPrice, QuickPrice, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }
}

extension QuickPriceQueryProperty
    on QueryBuilder<QuickPrice, QuickPrice, QQueryProperty> {
  QueryBuilder<QuickPrice, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<QuickPrice, int, QQueryOperations> indexIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'indexId');
    });
  }

  QueryBuilder<QuickPrice, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSupplierPriceCollection on Isar {
  IsarCollection<SupplierPrice> get supplierPrices => this.collection();
}

const SupplierPriceSchema = CollectionSchema(
  name: r'SupplierPrice',
  id: 7028661188147364569,
  properties: {
    r'deviceBrand': PropertySchema(
      id: 0,
      name: r'deviceBrand',
      type: IsarType.string,
    ),
    r'deviceModel': PropertySchema(
      id: 1,
      name: r'deviceModel',
      type: IsarType.string,
    ),
    r'partQuality': PropertySchema(
      id: 2,
      name: r'partQuality',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 3,
      name: r'price',
      type: IsarType.double,
    ),
    r'supplierName': PropertySchema(
      id: 4,
      name: r'supplierName',
      type: IsarType.string,
    )
  },
  estimateSize: _supplierPriceEstimateSize,
  serialize: _supplierPriceSerialize,
  deserialize: _supplierPriceDeserialize,
  deserializeProp: _supplierPriceDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'supplierName': IndexSchema(
      id: -5059668524112742578,
      name: r'supplierName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'supplierName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deviceBrand': IndexSchema(
      id: -5285115529250387388,
      name: r'deviceBrand',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deviceBrand',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deviceModel': IndexSchema(
      id: -2217596787306116846,
      name: r'deviceModel',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deviceModel',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _supplierPriceGetId,
  getLinks: _supplierPriceGetLinks,
  attach: _supplierPriceAttach,
  version: '3.1.0+1',
);

int _supplierPriceEstimateSize(
  SupplierPrice object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceBrand.length * 3;
  bytesCount += 3 + object.deviceModel.length * 3;
  bytesCount += 3 + object.partQuality.length * 3;
  bytesCount += 3 + object.supplierName.length * 3;
  return bytesCount;
}

void _supplierPriceSerialize(
  SupplierPrice object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.deviceBrand);
  writer.writeString(offsets[1], object.deviceModel);
  writer.writeString(offsets[2], object.partQuality);
  writer.writeDouble(offsets[3], object.price);
  writer.writeString(offsets[4], object.supplierName);
}

SupplierPrice _supplierPriceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SupplierPrice();
  object.deviceBrand = reader.readString(offsets[0]);
  object.deviceModel = reader.readString(offsets[1]);
  object.isarId = id;
  object.partQuality = reader.readString(offsets[2]);
  object.price = reader.readDouble(offsets[3]);
  object.supplierName = reader.readString(offsets[4]);
  return object;
}

P _supplierPriceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _supplierPriceGetId(SupplierPrice object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _supplierPriceGetLinks(SupplierPrice object) {
  return [];
}

void _supplierPriceAttach(
    IsarCollection<dynamic> col, Id id, SupplierPrice object) {
  object.isarId = id;
}

extension SupplierPriceQueryWhereSort
    on QueryBuilder<SupplierPrice, SupplierPrice, QWhere> {
  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SupplierPriceQueryWhere
    on QueryBuilder<SupplierPrice, SupplierPrice, QWhereClause> {
  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      supplierNameEqualTo(String supplierName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supplierName',
        value: [supplierName],
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      supplierNameNotEqualTo(String supplierName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supplierName',
              lower: [],
              upper: [supplierName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supplierName',
              lower: [supplierName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supplierName',
              lower: [supplierName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supplierName',
              lower: [],
              upper: [supplierName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      deviceBrandEqualTo(String deviceBrand) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deviceBrand',
        value: [deviceBrand],
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      deviceBrandNotEqualTo(String deviceBrand) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceBrand',
              lower: [],
              upper: [deviceBrand],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceBrand',
              lower: [deviceBrand],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceBrand',
              lower: [deviceBrand],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceBrand',
              lower: [],
              upper: [deviceBrand],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      deviceModelEqualTo(String deviceModel) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deviceModel',
        value: [deviceModel],
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterWhereClause>
      deviceModelNotEqualTo(String deviceModel) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceModel',
              lower: [],
              upper: [deviceModel],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceModel',
              lower: [deviceModel],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceModel',
              lower: [deviceModel],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceModel',
              lower: [],
              upper: [deviceModel],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SupplierPriceQueryFilter
    on QueryBuilder<SupplierPrice, SupplierPrice, QFilterCondition> {
  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceBrand',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceBrand',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceBrand',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceBrand',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceBrandIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceBrand',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      deviceModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceModel',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partQuality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partQuality',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partQuality',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partQuality',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      partQualityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partQuality',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supplierName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supplierName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supplierName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supplierName',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterFilterCondition>
      supplierNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supplierName',
        value: '',
      ));
    });
  }
}

extension SupplierPriceQueryObject
    on QueryBuilder<SupplierPrice, SupplierPrice, QFilterCondition> {}

extension SupplierPriceQueryLinks
    on QueryBuilder<SupplierPrice, SupplierPrice, QFilterCondition> {}

extension SupplierPriceQuerySortBy
    on QueryBuilder<SupplierPrice, SupplierPrice, QSortBy> {
  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> sortByDeviceBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      sortByDeviceBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> sortByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      sortByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> sortByPartQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partQuality', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      sortByPartQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partQuality', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      sortBySupplierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      sortBySupplierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.desc);
    });
  }
}

extension SupplierPriceQuerySortThenBy
    on QueryBuilder<SupplierPrice, SupplierPrice, QSortThenBy> {
  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByDeviceBrand() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      thenByDeviceBrandDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceBrand', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByDeviceModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      thenByDeviceModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceModel', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByPartQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partQuality', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      thenByPartQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partQuality', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      thenBySupplierName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.asc);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QAfterSortBy>
      thenBySupplierNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supplierName', Sort.desc);
    });
  }
}

extension SupplierPriceQueryWhereDistinct
    on QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> {
  QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> distinctByDeviceBrand(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceBrand', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> distinctByDeviceModel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceModel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> distinctByPartQuality(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partQuality', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<SupplierPrice, SupplierPrice, QDistinct> distinctBySupplierName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supplierName', caseSensitive: caseSensitive);
    });
  }
}

extension SupplierPriceQueryProperty
    on QueryBuilder<SupplierPrice, SupplierPrice, QQueryProperty> {
  QueryBuilder<SupplierPrice, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SupplierPrice, String, QQueryOperations> deviceBrandProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceBrand');
    });
  }

  QueryBuilder<SupplierPrice, String, QQueryOperations> deviceModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceModel');
    });
  }

  QueryBuilder<SupplierPrice, String, QQueryOperations> partQualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partQuality');
    });
  }

  QueryBuilder<SupplierPrice, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<SupplierPrice, String, QQueryOperations> supplierNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supplierName');
    });
  }
}
