double checkDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else if (value is int) {
    return 0.00 + value;
  } else {
    return value;
  }
}

int checkInt(dynamic value) {
  if (value is String) {
    return int.parse(value);
  } else if (value is int) {
    return 0 + value;
  } else {
    return value;
  }
}
