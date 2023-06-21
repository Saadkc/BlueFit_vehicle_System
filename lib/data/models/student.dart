class Student {
  Student(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.currentAddress,
      required this.permanentAddress,
      required this.email,
      required this.mobile,
      required this.image,
      required this.dob,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required this.classSectionId,
      required this.categoryId,
      required this.admissionNo,
      required this.rollNumber,
      required this.caste,
      required this.religion,
      required this.admissionDate,
      required this.bloodGroup,
      required this.height,
      required this.weight,
      required this.fatherId,
      required this.guardianId,
      required this.motherId,
      required this.isNewAdmission,
      required this.categoryName,
      required this.classSectionName,
      required this.mediumName});
  late final int id;
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String currentAddress;
  late final String permanentAddress;
  late final String mobile;
  late final String image;
  late final String dob;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final int userId;
  late final int classSectionId;
  late final int categoryId;
  late final String admissionNo;
  late final int rollNumber;
  late final String caste;
  late final String religion;
  late final String admissionDate;
  late final String bloodGroup;
  late final String height;
  late final String weight;
  late final int fatherId;
  late final int motherId;
  late final int guardianId;
  late final int isNewAdmission;
  late final String classSectionName;
  late final String mediumName;
  late final String categoryName;

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;

    lastName = json['last_name'] ?? "";
    firstName = json['first_name'] ?? "";
    currentAddress = json['current_address'] ?? "";
    permanentAddress = json['permanent_address'] ?? "";

    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    dob = json['dob'] ?? "";
    status = json['status'] ?? 0;
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    userId = json['user_id'] ?? 0;
    classSectionId = json['class_section_id'] ?? 0;
    categoryId = json['category_id'] ?? 0;
    admissionNo = json['admission_no'] ?? "";
    rollNumber = json['roll_number'] ?? 0;
    caste = json['caste'] ?? "";
    religion = json['religion'] ?? "";
    admissionDate = json['admission_date'] ?? "";
    bloodGroup = json['blood_group'] ?? "";
    height = json['height'] ?? "";
    weight = json['weight'] ?? "";
    fatherId = json['father_id'] ?? 0;
    motherId = json['mother_id'] ?? 0;
    guardianId = json['guardian_id'] ?? 0;
    isNewAdmission = json['is_new_admission'] ?? 0;
    classSectionName = json['class_section_name'] ?? "";
    mediumName = json['medium_name'] ?? "";
    categoryName = json['category_name'] ?? "";
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['last_name'] = lastName;
    _data['first_name'] = firstName;
    _data['current_address'] = currentAddress;
    _data['permanent_address'] = permanentAddress;
    _data['email'] = email;
    _data['mobile'] = mobile;
    _data['image'] = image;
    _data['dob'] = dob;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['user_id'] = userId;
    _data['class_section_id'] = classSectionId;
    _data['category_id'] = categoryId;
    _data['admission_no'] = admissionNo;
    _data['roll_number'] = rollNumber;
    _data['caste'] = caste;
    _data['religion'] = religion;
    _data['admission_date'] = admissionDate;
    _data['blood_group'] = bloodGroup;
    _data['height'] = height;
    _data['weight'] = weight;
    _data['father_id'] = fatherId;
    _data['mother_id'] = motherId;
    _data['guardian_id'] = guardianId;
    _data['is_new_admission'] = isNewAdmission;
    _data['class_section_name'] = classSectionName;
    _data['medium_name'] = mediumName;
    _data['category_name'] = categoryName;
    return _data;
  }
}
