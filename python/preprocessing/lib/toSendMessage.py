#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 14 00:57:44 2021

@author: yutasuzuki
"""


import smtplib
from email.mime.text import MIMEText
from email.utils import formatdate
import slackweb

class toSendMessage:    
    def __init__(self, MAIL_ADDRESS):
        self.MAIL_ADDRESS = MAIL_ADDRESS
        
        self.smtpobj = smtplib.SMTP('smtp.gmail.com', 587)
        self.smtpobj.ehlo()
        self.smtpobj.starttls()
        self.smtpobj.ehlo()
        PASSWORD = "Mkismn1923"
        self.smtpobj.login(MAIL_ADDRESS, PASSWORD)
        self.slack = slackweb.Slack(url="https://hooks.slack.com/services/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")
    
    def send_mail(self,body):
        msg = MIMEText(body)
        msg['Subject'] = 'Kabu Report'
        msg['From'] = self.MAIL_ADDRESS
        msg['To'] = self.MAIL_ADDRESS
        msg['Date'] = formatdate()
           
        self.smtpobj.sendmail(self.MAIL_ADDRESS, self.MAIL_ADDRESS, msg.as_string())
        self.smtpobj.close()

    def send_slack(self,text):
         
        self.slack.notify(text=text)
   
