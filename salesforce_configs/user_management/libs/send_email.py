# Import smtplib for the actual sending function
import smtplib

# Import the email modules we'll need
from email.mime.text import MIMEText


def send_notification_email(username, recipient, instance):
    from_address = "noreply@teliacompany.com"
    to_address = recipient
    subject = "SalesForce user activated"
    
    text = """
            Your SalesForce user was activated with username: {0}

            To log in, please go to the following URL: {1}

            Your password is the same as in production or the same password you used when you last logged in to this environment.
            If you don't remember your password, please press the 'Forgot your password?' link in the login page.
            """.format(username, "https://" + instance + ".salesforce.com")

    msg = MIMEText(text)
    msg['Subject'] = subject
    msg["From"] = from_address
    msg["To"] = to_address   

    s = smtplib.SMTP('smtp.dave.sonera.fi', "25")
    s.sendmail(from_address, to_address, msg.as_string())
    s.quit()

def send_password_clarification_email(recipients, env, wiki_list):
    from_address = "noreply@teliacompany.com"
    subject = "Salesforce sanbox refreshed"
    text = "Hi,\n" +\
    "{0} sanbox was just refreshed. ".format(env.upper()) +\
    "You are listed in http://wiki.intra.sonera.fi/pages/viewpage.action?spaceKey=BD&title=List+of+{0}+users ".format(wiki_list) +\
    "which caused your user to be either activated (1) or created (2) in which case you received one of the following emails: \n\n" +\
    "1) Change your email address. The refresh takes data from production environment and adds \"@example.com\" at the end of your email address. " +\
    "The automated script changes your email to the correct format and Salesforce sends you an automatic email to verify the email change. Verify your " +\
    "account from the email sent from Salesforce to activate your user in the {0} sandbox.\n\n".format(env.upper()) +\
    "2) Reset your password. If a user is created by automation, Salesforce doesn't send an automatic email to notify the user. To notify users they have " +\
    "a user for the sandbox, we need to reset their password so that Salesforce sends a notification to finish resetting the password.\n\n" +\
    "If you received no email, then do nothing and we apologize for the spam. :)\n\n" +\
    "Sincerely,\n" +\
    "System Team"

    msg = MIMEText(text)
    msg['Subject'] = subject
    msg["From"] = from_address

    s = smtplib.SMTP('smtp.dave.sonera.fi', "25")
    s.sendmail(from_address, recipients, msg.as_string())
    s.quit()

if __name__ == '__main__':
    send_password_clarification_email(["aleksi.simell@teliacompany.com", "jukka.pajunen@teliacompany.com"], "preprod", "test")