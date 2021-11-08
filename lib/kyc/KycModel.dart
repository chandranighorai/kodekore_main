class KycModel {
  KycData kycData;
  int success;
  String message;

  KycModel({this.kycData, this.success, this.message});

  KycModel.fromJson(Map<String, dynamic> json) {
    kycData = json['respData'] != null
        ? new KycData.fromJson(json['respData'])
        : null;
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kycData != null) {
      data['respData'] = this.kycData.toJson();
    }
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class KycData {
  String userId;
  String bankName;
  String branchName;
  String acNo;
  String ifsc;
  String acName;
  String panNo;
  String aadhaarNo;
  String kycPanFile;
  String kycAadhaarFile;
  String kycType;
  String kycStatus;

  KycData(
      {this.userId,
      this.bankName,
      this.branchName,
      this.acNo,
      this.ifsc,
      this.acName,
      this.panNo,
      this.aadhaarNo,
      this.kycPanFile,
      this.kycAadhaarFile,
      this.kycType,
      this.kycStatus});

  KycData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    acNo = json['ac_no'];
    ifsc = json['ifsc'];
    acName = json['ac_name'];
    panNo = json['pan_no'];
    aadhaarNo = json['aadhaar_no'];
    kycPanFile = json['kyc_pan_file'];
    kycAadhaarFile = json['kyc_aadhaar_file'];
    kycType = json['kyc_type'];
    kycStatus = json['kyc_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['bank_name'] = this.bankName;
    data['branch_name'] = this.branchName;
    data['ac_no'] = this.acNo;
    data['ifsc'] = this.ifsc;
    data['ac_name'] = this.acName;
    data['pan_no'] = this.panNo;
    data['aadhaar_no'] = this.aadhaarNo;
    data['kyc_pan_file'] = this.kycPanFile;
    data['kyc_aadhaar_file'] = this.kycAadhaarFile;
    data['kyc_type'] = this.kycType;
    data['kyc_status'] = this.kycStatus;
    return data;
  }
}
