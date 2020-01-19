class ChildrenEntity {
	dynamic next;
	dynamic previous;
	int count;
	List<childResults> results;

	ChildrenEntity({this.next, this.previous, this.count, this.results});

	ChildrenEntity.fromJson(Map<String, dynamic> json) {
		next = json['next'];
		previous = json['previous'];
		count = json['count'];
		if (json['results'] != null) {
			results = new List<childResults>();(json['results'] as List).forEach((v) { results.add(new childResults.fromJson(v)); });
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

class childResults {
	String classgroup;
	String name;
	int id;

	childResults({this.classgroup, this.name, this.id});

	childResults.fromJson(Map<String, dynamic> json) {
		classgroup = json['classgroup'];
		name = json['name'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['classgroup'] = this.classgroup;
		data['name'] = this.name;
		data['id'] = this.id;
		return data;
	}
}
