package cn.edu.hlju.tour.core.utils;

/**
 * Created by Sole on 2017/3/2.
 */
public class MailConfig {

    // 发件人的 邮箱 和 密码（替换为自己的邮箱和密码）
    private String senderEmail;

    private String senderPassword;

    // 发件人邮箱的 SMTP 服务器地址, 必须准确, 不同邮件服务器地址不同, 一般格式为: smtp.xxx.com
    // QQ邮箱的 SMTP 服务器地址为: smtp.qq.com
    private String senderEmailSMTPHost;

    private String smtpAuth;

    private String transportProtocol;


    public MailConfig() {

    }

    public String getSenderEmail() {
        return senderEmail;
    }

    public void setSenderEmail(String senderEmail) {
        this.senderEmail = senderEmail;
    }

    public String getSenderPassword() {
        return senderPassword;
    }

    public void setSenderPassword(String senderPassword) {
        this.senderPassword = senderPassword;
    }

    public String getSmtpAuth() {
        return smtpAuth;
    }

    public void setSmtpAuth(String smtpAuth) {
        this.smtpAuth = smtpAuth;
    }

    public String getSenderEmailSMTPHost() {
        return senderEmailSMTPHost;
    }

    public void setSenderEmailSMTPHost(String senderEmailSMTPHost) {
        this.senderEmailSMTPHost = senderEmailSMTPHost;
    }

    public String getTransportProtocol() {
        return transportProtocol;
    }

    public void setTransportProtocol(String transportProtocol) {
        this.transportProtocol = transportProtocol;
    }

    @Override
    public String toString() {
        return "MailConfig{" +
                "senderEmail='" + senderEmail + '\'' +
                ", senderPassword='" + senderPassword + '\'' +
                ", senderEmailSMTPHost='" + senderEmailSMTPHost + '\'' +
                ", smtpAuth='" + smtpAuth + '\'' +
                ", transportProtocol='" + transportProtocol + '\'' +
                '}';
    }

}
