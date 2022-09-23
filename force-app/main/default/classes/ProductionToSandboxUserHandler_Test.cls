@isTest
private class ProductionToSandboxUserHandler_Test {
    private static final Map<String, String> attributes = new Map<String, String>{
        'User.Alias' => 'standt',
        'User.Email' => 'test@example.com',
        'User.EmailEncodingKey' => 'UTF-8',
        'User.LastName' => 'test',
        'User.LanguageLocaleKey' => 'en_US',
        'User.ProfileId' => 'System Administrator',
        'User.TimeZoneSidKey' => 'America/Los_Angeles',
        'User.Username' => 'test@example.com'
    };

    @isTest
    static void createUser() {
        Test.startTest();
        ProductionToSandboxUserHandler handler = new ProductionToSandboxUserHandler();
        User newUser = handler.createUser(null, null, null, 'test@example.com', attributes, '');
        Test.stopTest();
        System.assertEquals(newUser.Email, attributes.get('User.Email'));
    }

    @isTest
    static void createUserProfileException() {
        Test.startTest();
        ProductionToSandboxUserHandler handler = new ProductionToSandboxUserHandler();
        Map<String, String> newAttributes = attributes.clone();
        newAttributes.put('User.ProfileId', 'profilenamethatdoesnotexist');
        try {
            User newUser = handler.createUser(
                null,
                null,
                null,
                'test@example.com',
                newAttributes,
                ''
            );
            System.assert(false);
        } catch (Exception e) {
            System.assert(e.getMessage().contains('profile does not exist.'));
        }
        Test.stopTest();
    }
}
