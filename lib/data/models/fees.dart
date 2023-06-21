class Fees {
  int? id;
  String? name;
  String? description;
  late bool isOptional;
  double? amount;
  double? dueCharges;
  bool? isDueData;
  Fees(
      {this.id,
      this.name,
      this.description,
      this.isOptional = false,
      this.dueCharges,
      this.isDueData = false,
      this.amount});

  Fees.fromFeesJson(Map<String, dynamic> json, {bool dueData = false}) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isOptional = ((json['choiceable'] == 0 || dueData == true) ? false : true);
    amount = (json['amount'] != null)
        ? double.parse(json['amount'].toString())
        : 0.0;
    isDueData = dueData;
    dueCharges = dueData ? double.parse(json['due_charges'].toString()) : 0.0;
  }
}

class feesDue {
  late final String dueDate;
  double? dueCharges;

  feesDue(this.dueDate, this.dueCharges);
  feesDue.fromJson(Map<String, dynamic> json) {
    dueCharges = double.parse(json['due_charges'].toString());
    dueDate = json['due_date'].toString();
  }
}
