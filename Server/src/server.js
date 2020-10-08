const ACTION_UPDATE_POSITION = 'update_position';
const ACTION_JOIN_PLAYER = 'join_player';

const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 5000 });


let players = []

wss.on('connection', function connection(ws) {
  var socketAddr = ws._socket.remoteAddress.replace("::ffff:", "");
  console.log('Connection from ' + socketAddr + " - " + new Date());

  ws.on('message', function incoming(message) {
    message = message.toString();
    const message_json = JSON.parse(message);
    const action = message_json['action'];
    const player_name = message_json['player_name'];

    if (action == ACTION_JOIN_PLAYER) {
      console.log(`${player_name} join the game`);
      players.push({
        name: player_name,
        position: [255, 256],
      });
      // Enviar mensagem para todos, menos a si proprio
      wss.clients.forEach(function each(client) {
        if (client !== ws && client.readyState === WebSocket.OPEN) {
          const data = {action: 'new_player', player_name: player_name}
          client.send(JSON.stringify(data));
        }
      });
    }

    if (action == ACTION_UPDATE_POSITION) {
      // Encontra na lista o player que irá se mexer
      const player_to_update = players.find(function(i){
        return i.name == player_name
      });
      // Altera a posição do player
      let updated_position = player_to_update.position;
      switch (message_json['direction']) {
        case 'up':
          updated_position[1] -= 16;
          break;
        case 'down':
          updated_position[1] += 16;
          break;
        case 'left':
          updated_position[0] -= 16;
          break;
        case 'right':
          updated_position[0] += 16;
          break;
      }
      player_to_update.position = updated_position;
    }
    // console.log(players);

    // Enviar mensagem para todos
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        const data = {action: 'update_positions', data: players}
        client.send(JSON.stringify(data));
      }
    });
  });

  ws.on('close', function close() {
    console.log('client disconnected');
  });

});

console.log("server running on port", 5000);
