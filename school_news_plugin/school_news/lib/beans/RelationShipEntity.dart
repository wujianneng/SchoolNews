class RelationShipEntity {
	String msg;
	int code;
	List<RelationShipData> data;
	String level;

	RelationShipEntity({this.msg, this.code, this.data, this.level});

	RelationShipEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<RelationShipData>();(json['data'] as List).forEach((v) { data.add(new RelationShipData.fromJson(v)); });
		}
		level = json['level'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		data['level'] = this.level;
		return data;
	}
}

class RelationShipData {
	String name;
	int id;

	RelationShipData({this.name, this.id});

	RelationShipData.fromJson(Map<String, dynamic> json) {
		name = json['name'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = this.name;
		data['id'] = this.id;
		return data;
	}
}
