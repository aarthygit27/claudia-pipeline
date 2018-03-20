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
