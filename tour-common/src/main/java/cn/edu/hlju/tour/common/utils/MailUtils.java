package cn.edu.hlju.tour.common.utils;

import com.sun.mail.util.MailSSLSocketFactory;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.security.GeneralSecurityException;
import java.util.Date;
import java.util.Properties;

/**
 * Created by lft on 2017/3/1.
 */
public class MailUtils {

    public static Properties getProps(String transportProtocol, String senderEmailSMTPHost, String smtpAuth) {
        Properties props = new Properties();                                // 参数配置
        props.setProperty("mail.transport.protocol", transportProtocol);    // 使用的协议（JavaMail规范要求）
        props.setProperty("mail.host", senderEmailSMTPHost);                // 发件人的邮箱的 SMTP 服务器地址
        props.setProperty("mail.smtp.auth", smtpAuth);                      // 请求认证，参数名称与具体实现有关
        props.setProperty("mail.debug", "true");
        MailSSLSocketFactory sf = null;
        try {
            sf = new MailSSLSocketFactory();
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
        }
        sf.setTrustAllHosts(true);
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.socketFactory", sf);
        return props;
    }

    /**
     * 创建一封只包含文本的简单邮件
     *
     * 前三项看配置文件
     * @param sendMail      发件人邮箱
     * @param sendNick      发件人昵称
     * @param sendPassword  发件人密码
     * @param receiveMail   收件人邮箱
     * @param receiveNick   收件人昵称
     * @param subject       主题
     * @param content       内容
     * @param charset       编码格式
     * @return  邮件
     * @throws Exception
     */
    public static void send(String transportProtocol, String sendeEmailSMTPHost, String smtpAuth,
                            String sendMail, String sendNick, String sendPassword,
                            String receiveMail, String receiveNick,
                            String subject, String content, String charset) {
        // 1. 创建参数配置, 用于连接邮件服务器的参数配置
        Properties props = getProps(transportProtocol, sendeEmailSMTPHost, smtpAuth);
        // 2. 根据配置创建会话对象, 用于和邮件服务器交互
        Session session = Session.getDefaultInstance(props);

        session.setDebug(true);     // 设置为debug模式, 可以查看详细的发送 log
        Transport transport = null;
        // 3. 创建一封邮件
        try {
            MimeMessage message = createMimeMessage(session, sendMail, receiveMail, sendNick, receiveNick, subject, content, charset);
            // 4. 根据 Session 获取邮件传输对象
            transport = session.getTransport();
            // 5. 使用 邮箱账号 和 密码 连接邮件服务器
            // 这里认证的邮箱必须与 message 中的发件人邮箱一致，否则报错
            transport.connect(sendMail, sendPassword);
            // 6. 发送邮件, 发到所有的收件地址, message.getAllRecipients() 获取到的是在创建邮件对象时添加的所有收件人, 抄送人, 密送人
            transport.sendMessage(message, message.getAllRecipients());
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 7. 关闭连接
            if (transport != null) {
                try {
                    transport.close();
                } catch (MessagingException e) {
                    e.printStackTrace();
                }
            }
        }

    }


    /**
     * 创建一封只包含文本的简单邮件
     *
     * @param session     和服务器交互的会话
     * @param sendMail    发件人邮箱
     * @param receiveMail 收件人邮箱
     * @param sendNick    发件人昵称
     * @param receiveNick 收件人昵称
     * @param subject     主题
     * @param content     内容
     * @param charset     编码格式
     * @return  邮件
     * @throws Exception
     */
    public static MimeMessage createMimeMessage(Session session, String sendMail, String receiveMail, String sendNick, String receiveNick, String subject, String content, String charset) throws Exception {
        // 1. 创建一封邮件
        MimeMessage message = new MimeMessage(session);
        // 2. From: 发件人
        message.setFrom(new InternetAddress(sendMail, sendNick, charset));
        // 3. To: 收件人（可以增加多个收件人、抄送、密送）
        message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(receiveMail, receiveNick, charset));
        // 4. Subject: 邮件主题
        message.setSubject(subject, charset);
        // 5. Content: 邮件正文（可以使用html标签）
        message.setContent(content, "text/html;charset=UTF-8");
        // 6. 设置发件时间
        message.setSentDate(new Date());
        // 7. 保存设置
        message.saveChanges();
        return message;
    }

}