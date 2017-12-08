<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>contact_outbound_message</fullName>
        <apiVersion>39.0</apiVersion>
        <description>send all contact fields to an endpoint</description>
        <endpointUrl>https://emily.extra.sonera.fi:62100/SFOutboundContactService</endpointUrl>
        <fields>AccountId</fields>
        <fields>AssistantName</fields>
        <fields>AssistantPhone</fields>
        <fields>Birthdate</fields>
        <fields>CanAllowPortalSelfReg</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Days_Uncontacted__c</fields>
        <fields>Department</fields>
        <fields>Description</fields>
        <fields>DoNotCall</fields>
        <fields>Email</fields>
        <fields>EmailBouncedDate</fields>
        <fields>EmailBouncedReason</fields>
        <fields>Fax</fields>
        <fields>FirstName</fields>
        <fields>HasOptedOutOfEmail</fields>
        <fields>HasOptedOutOfFax</fields>
        <fields>HomePhone</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>IsEmailBounced</fields>
        <fields>Jigsaw</fields>
        <fields>JigsawContactId</fields>
        <fields>LastActivityDate</fields>
        <fields>LastCURequestDate</fields>
        <fields>LastCUUpdateDate</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>LastName</fields>
        <fields>LastReferencedDate</fields>
        <fields>LastViewedDate</fields>
        <fields>Last_Contacted_Date__c</fields>
        <fields>LeadSource</fields>
        <fields>MailingCity</fields>
        <fields>MailingCountry</fields>
        <fields>MailingCountryCode</fields>
        <fields>MailingGeocodeAccuracy</fields>
        <fields>MailingLatitude</fields>
        <fields>MailingLongitude</fields>
        <fields>MailingPostalCode</fields>
        <fields>MailingState</fields>
        <fields>MailingStateCode</fields>
        <fields>MailingStreet</fields>
        <fields>MasterRecordId</fields>
        <fields>MobilePhone</fields>
        <fields>OtherCity</fields>
        <fields>OtherCountry</fields>
        <fields>OtherCountryCode</fields>
        <fields>OtherGeocodeAccuracy</fields>
        <fields>OtherLatitude</fields>
        <fields>OtherLongitude</fields>
        <fields>OtherPhone</fields>
        <fields>OtherPostalCode</fields>
        <fields>OtherState</fields>
        <fields>OtherStreet</fields>
        <fields>OwnerId</fields>
        <fields>Phone</fields>
        <fields>PhotoUrl</fields>
        <fields>RecordTypeId</fields>
        <fields>ReportsToId</fields>
        <fields>Salutation</fields>
        <fields>SystemModstamp</fields>
        <fields>Title</fields>
        <fields>telia_3rd_party__c</fields>
        <fields>telia_AIDA_ID__c</fields>
        <fields>telia_Contact_SF_ID__c</fields>
        <fields>telia_Last_Modified_By_External_User__c</fields>
        <fields>telia_OutboundMessageError__c</fields>
        <fields>telia_OutboundMessageStatus__c</fields>
        <fields>telia_Phone__c</fields>
        <fields>telia_aai_all__c</fields>
        <fields>telia_aai_assurance__c</fields>
        <fields>telia_aai_billing__c</fields>
        <fields>telia_aai_manage__c</fields>
        <fields>telia_aai_order__c</fields>
        <fields>telia_aai_other__c</fields>
        <fields>telia_aai_reporting__c</fields>
        <fields>telia_aai_sonera__c</fields>
        <fields>telia_ari_agreement__c</fields>
        <fields>telia_ari_billing__c</fields>
        <fields>telia_ari_contact__c</fields>
        <fields>telia_ari_mobile__c</fields>
        <fields>telia_ari_other__c</fields>
        <fields>telia_ari_portal__c</fields>
        <fields>telia_ari_service__c</fields>
        <fields>telia_ari_technical__c</fields>
        <fields>telia_auth_all__c</fields>
        <fields>telia_auth_assurance__c</fields>
        <fields>telia_auth_billing__c</fields>
        <fields>telia_auth_manage__c</fields>
        <fields>telia_auth_order__c</fields>
        <fields>telia_auth_other__c</fields>
        <fields>telia_auth_reporting__c</fields>
        <fields>telia_auth_sonera__c</fields>
        <fields>telia_business_card_title__c</fields>
        <fields>telia_consent_other__c</fields>
        <fields>telia_contact_ID__c</fields>
        <fields>telia_created_by_crm_user__c</fields>
        <fields>telia_created_by_external_user__c</fields>
        <fields>telia_email_verified_by__c</fields>
        <fields>telia_email_verified_date__c</fields>
        <fields>telia_external_email__c</fields>
        <fields>telia_external_id__c</fields>
        <fields>telia_external_office_name__c</fields>
        <fields>telia_external_status__c</fields>
        <fields>telia_gender__c</fields>
        <fields>telia_jobtitlecode__c</fields>
        <fields>telia_jobtitlecode_description__c</fields>
        <fields>telia_language__c</fields>
        <fields>telia_marketing_email__c</fields>
        <fields>telia_marketing_letter__c</fields>
        <fields>telia_marketing_phone__c</fields>
        <fields>telia_marketing_research__c</fields>
        <fields>telia_marketing_sms__c</fields>
        <fields>telia_marketing_traffic_data__c</fields>
        <fields>telia_mit_party_id__c</fields>
        <fields>telia_mobile_phone_verified_by__c</fields>
        <fields>telia_mobile_phone_verified_date__c</fields>
        <fields>telia_office_name__c</fields>
        <fields>telia_phone_verified_by__c</fields>
        <fields>telia_phone_verified_date__c</fields>
        <fields>telia_preferred_contact_channel__c</fields>
        <fields>telia_primary_email__c</fields>
        <fields>telia_primary_phone__c</fields>
        <fields>telia_relationship_attribute__c</fields>
        <fields>telia_roles_agreement__c</fields>
        <fields>telia_roles_billing__c</fields>
        <fields>telia_roles_contact__c</fields>
        <fields>telia_roles_mobile__c</fields>
        <fields>telia_roles_other__c</fields>
        <fields>telia_roles_portal__c</fields>
        <fields>telia_roles_service__c</fields>
        <fields>telia_roles_technical__c</fields>
        <fields>telia_sales_role__c</fields>
        <fields>telia_system_id__c</fields>
        <fields>vlocity_cmt__Age__c</fields>
        <fields>vlocity_cmt__AnnualIncome__c</fields>
        <fields>vlocity_cmt__Authorized__c</fields>
        <fields>vlocity_cmt__CustomerSentiment__c</fields>
        <fields>vlocity_cmt__DaysSinceLastContact__c</fields>
        <fields>vlocity_cmt__DriversLicenseNumber__c</fields>
        <fields>vlocity_cmt__EmploymentStatus__c</fields>
        <fields>vlocity_cmt__Image__c</fields>
        <fields>vlocity_cmt__IsActive__c</fields>
        <fields>vlocity_cmt__IsEmployee__c</fields>
        <fields>vlocity_cmt__IsPartner__c</fields>
        <fields>vlocity_cmt__IsPersonAccount__c</fields>
        <fields>vlocity_cmt__LastContactbyRecordOwner__c</fields>
        <fields>vlocity_cmt__Location__c</fields>
        <fields>vlocity_cmt__MiddleName__c</fields>
        <fields>vlocity_cmt__NetWorth__c</fields>
        <fields>vlocity_cmt__Occupation__c</fields>
        <fields>vlocity_cmt__PartyId__c</fields>
        <fields>vlocity_cmt__PrimaryEmployerId__c</fields>
        <fields>vlocity_cmt__SSN__c</fields>
        <fields>vlocity_cmt__SocialSecurityNumber__c</fields>
        <fields>vlocity_cmt__StateOfIssuance__c</fields>
        <fields>vlocity_cmt__Status__c</fields>
        <fields>vlocity_cmt__TaxId__c</fields>
        <fields>vlocity_cmt__Type__c</fields>
        <fields>vlocity_cmt__UserEmployeeNumber__c</fields>
        <fields>vlocity_cmt__UserId__c</fields>
        <fields>vlocity_cmt__WebSite__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ginte@teliacompany.com</integrationUser>
        <name>contact outbound message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
</Workflow>
