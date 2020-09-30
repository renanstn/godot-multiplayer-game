const ACTION_SET_POSITION = 'set_position';
const ACTION_UPDATE_POSITION = 'update_position';

const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 5000 });


let positions = {}
wss.on('connection', function connection(ws) {
  var socketAddr = ws._socket.remoteAddress.replace("::ffff:", "");
  console.log('Connection from ' + socketAddr + " - " + new Date());

  ws.on('open', function open() {
    console.log('connected');
  });

  ws.on('message', function incoming(message) {
    message = message.toString();
    message_json = JSON.parse(message);
    console.log('received message: ', message);
    const action = message_json['action'];
    const player = message_json['player'];

    if (action == ACTION_SET_POSITION) {
      positions[player] = {}
      positions[player]['position'] = [
        parseInt(message_json['position'][0]),
        parseInt(message_json['position'][1])
      ]
    }

    if (action == ACTION_UPDATE_POSITION) {
      let updated_position = positions[player]['position'];
      if (message_json['direction'] == 'up') {
        updated_position[1] += 16;
      } else if (message_json['direction'] == 'down') {
        updated_position[1] -= 16;
      } else if (message_json['direction'] == 'left') {
        updated_position[0] += 16;
      } else if (message_json['direction'] == 'right') {
        updated_position[0] -= 16;
      }
      positions[player]['position'] = updated_position;
    }

    console.log(positions);

    // Enviar mensagem para todos
    wss.clients.forEach(function each(client) {
      // if (client !== ws && client.readyState === WebSocket.OPEN) {
      //   client.send('message');
      // }
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(positions));
      }
    });
  });

  ws.on('close', function close() {
    console.log('client disconnected');
  });

});

console.log("server running on port", 5000);
