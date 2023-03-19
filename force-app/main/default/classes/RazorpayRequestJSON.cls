public with sharing class RazorpayRequestJSON {
    String currencyType = 'INR';
    String description = 'Payment for policy no #23456';
    String callback_url = 'https://cms-assets.tutsplus.com/cdn-cgi/image/width=850/uploads/users/523/posts/32694/final_image/tutorial-preview-large.png';
    String callback_method = 'get';

    public Decimal amount;
    public Decimal first_min_partial_amount;

    Boolean accept_partial = true;
    Boolean reminder_enable = true;
    
    Long expire_by = 1691097057;
    
    public Customer customer;
    public Notify notify = new Notify();
    public Notes notes;

    public class Customer{
        public String name;
        public String contact;
        public String email;

        Customer(String name, String contact, String email){
            this.name = name;
            this.contact = contact;
            this.email = email;
        }
    }

    public class Notify{
        boolean sms = true;
        boolean email = true;
    }

    public class Notes{
        public String policy_name;
        public String objectName;

        Notes(String policy_name,String objectName){
            this.policy_name = policy_name; 
            this.objectName = objectName;
        }
    }

    public void setCustomer(String name, String contact, String email){
        this.customer = new Customer(name, contact,email);
    }

    public void setNotes(String notesName,String objectName){
        this.notes = new Notes(notesName,objectName);
    }

    public RazorpayRequestJSON() {}
}