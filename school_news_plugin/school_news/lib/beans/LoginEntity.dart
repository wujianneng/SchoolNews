class LoginEntity {
	String msg;
	int code;
	LoginData data;
	String level;

	LoginEntity({this.msg, this.code, this.data, this.level});

	LoginEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
		level = json['level'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		data['level'] = this.level;
		return data;
	}
}

class LoginData {
	String devicebrand;
	String deviceversion;
	int userId;
	String profile;
	bool students;
	String devicetoken;
	String deviceostype;
	String token;

	LoginData({this.devicebrand, this.deviceversion, this.userId, this.profile, this.students, this.devicetoken, this.deviceostype, this.token});

	LoginData.fromJson(Map<String, dynamic> json) {
		devicebrand = json['devicebrand'];
		deviceversion = json['deviceversion'];
		userId = json['user_id'];
		profile = json['profile'];
		students = json['students'];
		devicetoken = json['devicetoken'];
		deviceostype = json['deviceostype'];
		token = json['token'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['devicebrand'] = this.devicebrand;
		data['deviceversion'] = this.deviceversion;
		data['user_id'] = this.userId;
		data['profile'] = this.profile;
		data['students'] = this.students;
		data['devicetoken'] = this.devicetoken;
		data['deviceostype'] = this.deviceostype;
		data['token'] = this.token;
		return data;
	}
}
