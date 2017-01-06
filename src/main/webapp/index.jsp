<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Spring + WebSocket 例子</title>
    <script src="/js/sockjs-0.3.min.js"></script>
    <script src="/js/stomp.js"></script>
    <script src="/js/jquery-1.10.2.js"></script>
    <script src="/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="/js/jquery.json.js"></script>
    <style>
        table{
            border: 1px solid #000000;
        }
        table th{
            border: 1px solid #000000;
            background-color: #889966;
        }
        table td{
            border: 1px solid #000000;
            background-color: #00ff00;
        }
    </style>
    <script>
        //创建sockJS协议
        var socket = new SockJS("/ws");
        var stompClient = Stomp.over(socket);

        //连接服务器
        stompClient.connect("guest", "guest", function () {
            //成功连接后，设定接受服务器的地址和处理方法
            stompClient.subscribe('/topic/price', function (frame) {
                //服务器返回请求处理
                var prices = JSON.parse(frame.body);
                $('#price').empty();
                for (var i in prices) {
                    var price = prices[i];
                    $('#price').append(
                            $('<tr>').append(
                                    $('<td>').html(price.code),
                                    $('<td>').html(price.price.toFixed(2)),
                                    $('<td>').html(price.timeStr)
                            )
                    );
                }
            });
        }, function (error) {
            //连接出现错误回调函数
            alert(error.headers.message);
        });

        // Register handler for add button
        $(document).ready(function () {
            $('.add').click(function (e) {
                e.preventDefault();
                var code = $('.new .code').val();
                var price = Number($('.new .price').val());
                var jsonstr = JSON.stringify({ 'code': code, 'price': price });
                //发送信息给服务器
                stompClient.send("/app/addStock", {}, jsonstr);
                return false;
            });
            $('.remove-all').click(function (e) {
                e.preventDefault();
                //发送信息给服务器
                stompClient.send("/app/removeAllStocks");
                return false;
            });
        });
    </script>
</head>
<body>
<h1>Spring + WebSocket 例子</h1>

<p class="new">
    编码: <input type="text" class="code"/>
    价格: <input type="text" class="price"/>
    <button class="add">增加</button>
    <button class="remove-all">移除所有</button>
</p>
<table style="width: 1000px;">
    <thead>
    <tr>
        <th style="width: 30%">编码</th>
        <th style="width: 30%">价格</th>
        <th style="width: 40%">时间</th>
    </tr>
    </thead>
    <tbody id="price">

    </tbody>
</table>
测试方式:
提交信息到服务器，服务器会定时发送数据到页面，不管多少个浏览器打开都能接收服务器发送来的信息。
</body>
</html>
