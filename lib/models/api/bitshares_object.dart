class BitsharesObject {
  static const String ID_KEY = "id";
  static const PROTOCOL_SPACE = 1;
  static const IMPL_SPACE = 2;

  final String id;
  int space;
  int type;
  int instance;

  BitsharesObject(this.id) {
    var split = id.split("\\.");
    if (split.length == 3) {
      space = int.parse(split[0]);
      type = int.parse(split[1]);
      instance = int.parse(split[2]);
    }
  }

  String getObjectId() {
    return "$space.$type.$instance";
  }

  ObjectType getObjectType() {
    switch (space) {
      case PROTOCOL_SPACE:
        {
          switch (type) {
            case 1:
              return ObjectType.BASE_OBJECT;
            case 2:
              return ObjectType.ACCOUNT_OBJECT;
            case 3:
              return ObjectType.ASSET_OBJECT;
            case 4:
              return ObjectType.FORCE_SETTLEMENT_OBJECT;
            case 5:
              return ObjectType.COMMITTEE_MEMBER_OBJECT;
            case 6:
              return ObjectType.WITNESS_OBJECT;
            case 7:
              return ObjectType.LIMIT_ORDER_OBJECT;
            case 8:
              return ObjectType.CALL_ORDER_OBJECT;
            case 9:
              return ObjectType.CUSTOM_OBJECT;
            case 10:
              return ObjectType.PROPOSAL_OBJECT;
            case 11:
              return ObjectType.OPERATION_HISTORY_OBJECT;
            case 12:
              return ObjectType.WITHDRAW_PERMISSION_OBJECT;
            case 13:
              return ObjectType.VESTING_BALANCE_OBJECT;
            case 14:
              return ObjectType.WORKER_OBJECT;
            case 15:
              return ObjectType.BALANCE_OBJECT;
          }
          break;
        }
      case IMPL_SPACE:
        switch (type) {
          case 0:
            return ObjectType.GLOBAL_PROPERTY_OBJECT;
          case 1:
            return ObjectType.DYNAMIC_GLOBAL_PROPERTY_OBJECT;
          case 3:
            return ObjectType.ASSET_DYNAMIC_DATA;
          case 4:
            return ObjectType.ASSET_BITASSET_DATA;
          case 5:
            return ObjectType.ACCOUNT_BALANCE_OBJECT;
          case 6:
            return ObjectType.ACCOUNT_STATISTICS_OBJECT;
          case 7:
            return ObjectType.TRANSACTION_OBJECT;
          case 8:
            return ObjectType.BLOCK_SUMMARY_OBJECT;
          case 9:
            return ObjectType.ACCOUNT_TRANSACTION_HISTORY_OBJECT;
          case 10:
            return ObjectType.BLINDED_BALANCE_OBJECT;
          case 11:
            return ObjectType.CHAIN_PROPERTY_OBJECT;
          case 12:
            return ObjectType.WITNESS_SCHEDULE_OBJECT;
          case 13:
            return ObjectType.BUDGET_RECORD_OBJECT;
          case 14:
            return ObjectType.SPECIAL_AUTHORITY_OBJECT;
        }
    }
    return ObjectType.BASE_OBJECT;
  }
}

enum ObjectType {
  BASE_OBJECT,
  ACCOUNT_OBJECT,
  ASSET_OBJECT,
  FORCE_SETTLEMENT_OBJECT,
  COMMITTEE_MEMBER_OBJECT,
  WITNESS_OBJECT,
  LIMIT_ORDER_OBJECT,
  CALL_ORDER_OBJECT,
  CUSTOM_OBJECT,
  PROPOSAL_OBJECT,
  OPERATION_HISTORY_OBJECT,
  WITHDRAW_PERMISSION_OBJECT,
  VESTING_BALANCE_OBJECT,
  WORKER_OBJECT,
  BALANCE_OBJECT,
  GLOBAL_PROPERTY_OBJECT,
  DYNAMIC_GLOBAL_PROPERTY_OBJECT,
  ASSET_DYNAMIC_DATA,
  ASSET_BITASSET_DATA,
  ACCOUNT_BALANCE_OBJECT,
  ACCOUNT_STATISTICS_OBJECT,
  TRANSACTION_OBJECT,
  BLOCK_SUMMARY_OBJECT,
  ACCOUNT_TRANSACTION_HISTORY_OBJECT,
  BLINDED_BALANCE_OBJECT,
  CHAIN_PROPERTY_OBJECT,
  WITNESS_SCHEDULE_OBJECT,
  BUDGET_RECORD_OBJECT,
  SPECIAL_AUTHORITY_OBJECT
}
