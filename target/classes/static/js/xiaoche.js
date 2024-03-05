// MQTT客户端类
function generateRandomClientId() {
    const timestamp = Date.now().toString(36); // 将当前时间戳转换为36进制字符串
   const randomString = Math.random().toString(36).substr(2); // 生成一个随机的字符串
   return `${timestamp}_${randomString}`;
}

const clientId = generateRandomClientId();
console.log("客户端ID:",clientId);
class MQTTClient {

constructor(serverUrl) {
   this.mqttClient = new Paho.MQTT.Client(serverUrl, clientId);
   this.mqttClient.onConnectionLost = this.onConnectionLost.bind(this);
   this.mqttClient.onMessageArrived = this.onMessageArrived.bind(this);
}

connect() {
   return new Promise((resolve, reject) => {
       this.mqttClient.connect({
           onSuccess: () => {
               console.log('成功连接到MQTT服务器');
               resolve();
           },
           onFailure: (err) => {
               console.error('连接失败:', err);
               reject(err);
           }
       });
   });
}

onConnectionLost(response) {
   if (response.errorCode !== 0) {
       console.error('连接丢失:', response.errorMessage);
   }
}

onMessageArrived(message) {
   console.log('接收到的消息为:', message.payloadString);
   const logElement = document.getElementById('log');

   const tableBody = document.querySelector('#messageTable tbody');
   const newRow = tableBody.insertRow();
   const clientCell = newRow.insertCell();
   const timeCell = newRow.insertCell();
   const topicCell = newRow.insertCell();
   const messageCell = newRow.insertCell();

   const currentTime = new Date().toLocaleTimeString();
   const topic = message.destinationName;
   const messageContent = message.payloadString;

   clientCell.textContent = clientId; // 添加客户端信息
   timeCell.textContent = currentTime;
   topicCell.textContent = topic;
   messageCell.textContent = messageContent;
}

subscribe(topic) {
   this.mqttClient.subscribe(topic);
   console.log('订阅到主题:', topic);
}

publish(topic, message) {
   let mqttMessage = new Paho.MQTT.Message(message);
   mqttMessage.destinationName = topic;

   this.mqttClient.send(mqttMessage);
   console.log('发布消息:', message);
}
}

// 创建MQTT客户端实例
let mqttClient;

// 连接到MQTT代理服务器
function connect() {
   //2023年12月7日13点30分
   //const password = prompt('请输入密码:');
   const date = new Date();
   const correctPassword = `${date.getHours()}${date.getMinutes()}`;

   // if (password !== correctPassword) {
   //     alert('密码错误!');
   //     return;
   // }

   const serverUrl = document.getElementById('serverInput').value;
   mqttClient = new MQTTClient(serverUrl);

   mqttClient.connect()
       .then(() => {
           // console.log('Connected');
           const connectionStatusElement = document.getElementById('connectionStatus');
           connectionStatusElement.textContent = '已连接';
       })
       .catch((err) => {
           console.error('连接失败:', err);
       });
}

// 断开服务器连接
function disconnect() {
   if (mqttClient) {
       mqttClient.mqttClient.disconnect();
       console.log('连接断开');
       const connectionStatusElement = document.getElementById('connectionStatus');
       connectionStatusElement.textContent = '已断开';
   } else {
       console.error('并未连接服务器!');
   }
}

// 发布消息
function publish() {
const topic = document.getElementById('publishTopicInput').value;
const message = document.getElementById('messageInput').value;

if (mqttClient) {
   mqttClient.publish(topic, message);
} else {
   console.error('并未连接服务器!');
}
}
function publish1() {
const topic = document.getElementById('publishTopicInput2').value;
const message = document.getElementById('messageInput2').value;

if (mqttClient) {
   mqttClient.publish(topic, message);
} else {
   console.error('并未连接服务器!');
}
}

function publish2() {
   const topic = document.getElementById('publishTopicInput3').value;
   const message = document.getElementById('messageInput3').value;

   if (mqttClient) {
       mqttClient.publish(topic, message);
   } else {
       console.error('并未连接服务器!');
   }
}

function publish3() {
   const topic = document.getElementById('publishTopicInput4').value;
   const message = document.getElementById('messageInput4').value;

   if (mqttClient) {
       mqttClient.publish(topic, message);
   } else {
       console.error('并未连接服务器!');
   }
}

function publish4() {
   const topic = document.getElementById('publishTopicInput5').value;
   const message = document.getElementById('messageInput5').value;

   if (mqttClient) {
       mqttClient.publish(topic, message);
   } else {
       console.error('并未连接服务器!');
   }
}

function publish5() {
    const topic = document.getElementById('publishTopicInput6').value;
    const message = document.getElementById('messageInput6').value;

    if (mqttClient) {
        mqttClient.publish(topic, message);
    } else {
        console.error('并未连接服务器!');
    }
}


// 订阅主题
function subscribe() {
const topic = document.getElementById('subscribeTopicInput').value;

if (mqttClient) {
   mqttClient.subscribe(topic);
} else {
   console.error('并未连接服务器!');
}
}