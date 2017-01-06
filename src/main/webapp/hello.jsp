<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%--
  ~ Copyright (c) 2014. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  ~ Morbi non lorem porttitor neque feugiat blandit. Ut vitae ipsum eget quam lacinia accumsan.
  ~ Etiam sed turpis ac ipsum condimentum fringilla. Maecenas magna.
  ~ Proin dapibus sapien vel ante. Aliquam erat volutpat. Pellentesque sagittis ligula eget metus.
  ~ Vestibulum commodo. Ut rhoncus gravida arcu.
  --%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Spring + WebSocket Hello world例子</title>
    <script src="/js/sockjs-0.3.min.js"></script>
    <script src="/js/stomp.js"></script>
    <script src="/js/jquery-1.10.2.js"></script>
    <script src="/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="/js/jquery.json.js"></script>
    <script>
        //创建sockJS协议
        var socket = new SockJS("/ws");
        var stompClient = Stomp.over(socket);
        //连接服务器
        stompClient.connect("guest", "guest", function () {
            $("#recFromServer").append("<br>" + "成功连接服务器.!");
            //成功连接后，设定接受服务器的地址和处理方法
            stompClient.subscribe('/topic/greetings', function (greeting) {
                var content = JSON.parse(greeting.body).content;
                $("#recFromServer").append("<br>" + content);
            });
        }, function (error) {
            //连接出现错误回调函数
            alert(error.headers.message);
        });


        function sendMessage() {
            //发送信息给服务器
            stompClient.send("/app/greeting", {}, JSON.stringify({ 'name': $("#message").val() }));
        }
    </script>
</head>
<body>
输入名称:
<input id="message" type="text">
<input type="button" onclick="sendMessage()" value="发送到服务器">
<div id="recFromServer"></div>
测试方式:
用两个浏览器打开这个页面，然后一个页面提交信息，它能接收到服务器的数据，同时另一个页面也能接收到服务器发送的数据。
</body>
</html>
