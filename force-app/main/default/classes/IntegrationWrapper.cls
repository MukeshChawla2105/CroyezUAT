global without sharing class IntegrationWrapper {
    
   global class APIResponseWrapper {
        public String message;
        public String status;

        public APIResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
}