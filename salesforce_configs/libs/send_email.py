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
    subject = "Salesforce {0} sandbox refreshed".format(env.upper())
    text = "Hi,\n" +\
    "{0} sandbox was recently refreshed. ".format(env.upper()) +\
    "You are listed in http://wiki.intra.sonera.fi/pages/viewpage.action?spaceKey=BD&title=List+of+{0}+users ".format(wiki_list) +\
    "which caused your user to be either activated (1) or created (2) in which case you received one of the following emails: \n\n" +\
    "1) Change your email address. Sandbox was refreshed and the refresh takes data from production environment, so if you have a user in production " +\
    "your user is automatically created to the sandbox and \"@example.com\" is added at the end of your email address. " +\
    "The automated script changes your email to the correct format and Salesforce sends you an automatic email to verify the change. Verify your " +\
    "account from the email sent from Salesforce to activate your user in the {0} sandbox.\n\n".format(env.upper()) +\
    "2) Reset your password. If a user is created by automation, Salesforce doesn't send an automatic email to notify the user. To notify users they have " +\
    "a user for the sandbox, we need to reset their password so that Salesforce sends a notification to finish resetting the password.\n\n" +\
    "If you received no email, then do nothing and we apologize for the spam.\n\n" +\
    "Your username in {0} sandbox is in [tcad]@teliacompany.com.{1} format, e.g. abc1234@teliacompany.com.{1}.\n\n".format(env.upper(), env.lower()) +\
    "If you had a user in production, your password in the sandbox is the same as in production. If you didn't have a user in production, you need to " +\
    "create a password with the password reset link as described in (2).\n\n" +\
    "In case you are still facing issues accessing the environments, please contact Aleksi Simell (aleksi.simell@teliacompany.com).\n\n" +\
    "Best regards,\n" +\
    "System Team"

    msg = MIMEText(text)
    msg['Subject'] = subject
    msg["From"] = from_address

    s = smtplib.SMTP('smtp.dave.sonera.fi', "25")
    s.sendmail(from_address, recipients, msg.as_string())
    s.quit()

if __name__ == '__main__':
    send_password_clarification_email(["aleksi.simell@teliacompany.com"], "preprod", "test")