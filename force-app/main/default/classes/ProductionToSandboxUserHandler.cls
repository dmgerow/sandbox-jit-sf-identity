global class ProductionToSandboxUserHandler implements Auth.SamlJitHandler {
    private static final String EXTERNAL_USER_MESSAGE = 'This handler cannot be used with external users.';
    private static final String PROFILE_KEY_PREFIX = '00e';
    private static final Set<String> INSERT_ONLY_FIELDS = new Set<String>{
        'username',
        'profileid',
        'roleid'
    };

    private static Map<String, Id> profileIdsByName {
        get {
            if (profileIdsByName == null) {
                profileIdsByName = new Map<String, Id>();
                for (Profile p : [SELECT Id, Name FROM Profile]) {
                    profileIdsByName.put(p.Name, p.Id);
                }
            }
            return profileIdsByName;
        }
        private set;
    }

    global User createUser(
        Id samlSsoProviderId,
        Id communityId,
        Id portalId,
        String federationIdentifier,
        Map<String, String> attributes,
        String assertion
    ) {
        if (communityId != null || portalId != null) {
            throw new JitException(EXTERNAL_USER_MESSAGE);
        }
        System.debug(JSON.serializePretty(attributes));
        try {
            User newUser = handleUser(
                true,
                new User(FederationIdentifier = federationIdentifier),
                attributes
            );
            System.debug(JSON.serializePretty(newUser));
            return newUser;
        } catch (Exception e) {
            throw new JitException(e.getMessage());
        }
    }

    global void updateUser(
        Id userId,
        Id samlSsoProviderId,
        Id communityId,
        Id portalId,
        String federationIdentifier,
        Map<String, String> attributes,
        String assertion
    ) {
        System.debug(JSON.serializePretty(attributes));
        try {
            update handleUser(false, new User(Id = userId), attributes);
        } catch (Exception e) {
            throw new JitException(e.getMessage());
        }
    }

    private User handleUser(Boolean isCreate, User user, Map<String, String> attributes) {
        for (String attribute : attributes.keySet()) {
            if (attribute.startsWith('User.')) {
                String fieldName = attribute.removeStart('User.').toLowerCase();
                if (isCreate || !INSERT_ONLY_FIELDS.contains(fieldName)) {
                    if (
                        fieldName == 'profileid' &&
                        !attributes.get(attribute).startsWith(PROFILE_KEY_PREFIX)
                    ) {
                        if (!profileIdsByName.containsKey(attributes.get(attribute))) {
                            throw new JitException(
                                attributes.get(attribute) + ' profile does not exist.'
                            );
                        }
                        user.put(fieldName, profileIdsByName.get(attributes.get(attribute)));
                    } else {
                        user.put(fieldName, attributes.get(attribute));
                    }
                }
            }
        }
        return user;
    }

    private class JitException extends Exception {
    }
}
