class NoticeListEntity {
	dynamic next;
	dynamic previous;
	int count;
	List<NoticeListResult> results;

	NoticeListEntity({this.next, this.previous, this.count, this.results});

	NoticeListEntity.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<NoticeListResult>();(json['results'] as List).forEach((v) { results.add(new NoticeListResult.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['next'] = this.next;
		data['previous'] = this.previous;
		data['count'] = this.count;
		if (this.results != null) {
      data['results'] =  this.results.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class NoticeListResult {
	String week;
	bool read;
	bool submitted;
	bool attachment;
	String subject;
	String publish;
	String description;
	int id;
	String time;

	NoticeListResult({this.week, this.read, this.submitted, this.attachment, this.subject, this.publish, this.description, this.id, this.time});

	NoticeListResult.fromJson(Map<String, dynamic> json) {
		week = json['week'];
		read = json['read'];
		submitted = json['submitted'];
		attachment = json['attachment'];
		subject = json['subject'];
		publish = json['publish'];
		description = json['description'];
		id = json['id'];
		time = json['time'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['week'] = this.week;
		data['read'] = this.read;
		data['submitted'] = this.submitted;
		data['attachment'] = this.attachment;
		data['subject'] = this.subject;
		data['publish'] = this.publish;
		data['description'] = this.description;
		data['id'] = this.id;
		data['time'] = this.time;
		return data;
	}
}
