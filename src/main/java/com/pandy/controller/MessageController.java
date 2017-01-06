/*
 * Copyright (c) 2014. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
 * Morbi non lorem porttitor neque feugiat blandit. Ut vitae ipsum eget quam lacinia accumsan.
 * Etiam sed turpis ac ipsum condimentum fringilla. Maecenas magna.
 * Proin dapibus sapien vel ante. Aliquam erat volutpat. Pellentesque sagittis ligula eget metus.
 * Vestibulum commodo. Ut rhoncus gravida arcu.
 */

package com.pandy.controller;

import com.pandy.domain.Greeting;
import com.pandy.domain.HelloMessage;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.util.Date;
/**
 *          由客户端触发，并接受服务器发送信息的例子
 */
@Controller
public class MessageController {
    @MessageMapping("/greeting")
    @SendTo("/topic/greetings")
    public Greeting greeting(HelloMessage message) throws Exception {
        System.out.println("MessageController====================================>客户端连接");
        return new Greeting("["+(new Date())+"]  服务器返回: Hello,客户端输入信息< " + message.getName() + ">");
    }
}