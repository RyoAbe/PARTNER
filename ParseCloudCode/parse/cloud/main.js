Parse.Cloud.define('removePartner', function(request, response) {
    var partnerId = request.params.partnerId;
    var User = Parse.Object.extend('_User');
    var partner = new User({ objectId: partnerId });

	partner.set("partner", null);
	partner.set("statuses", []);

    Parse.Cloud.useMasterKey();
    partner.save().then(function(partner) {
        response.success(partner);
    }, function(error) {
        response.error(error)
    });
});

Parse.Cloud.define('addPartner', function(request, response) {
    var partnerId = request.params.partnerId;
    var User = Parse.Object.extend('_User');
    var partner = new User({ objectId: partnerId });

	var currentUser = request.user;
    partner.set("partner", currentUser);
	partner.set("statuses", []);

    Parse.Cloud.useMasterKey();
    partner.save().then(function(partner) {
        response.success(partner);
    }, function(error) {
        response.error(error)
    });
});