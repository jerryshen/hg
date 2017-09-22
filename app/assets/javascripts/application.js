// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require app/base
//= require client
//= require app/validations
//= require app/script
//= require app/ui

// the client object
  client = NaN;
  // A helper function to print messages to a DIV called "output"
  function print2output(text) {
      var o = document.getElementById("output");
      o.innerHTML = "<li>" + text + "</li>" + o.innerHTML
  }
  // A helper function to disable a text input called "input"
  function disable_input() {
      document.getElementById("input").disabled = true;
  }
  // A helper function to enable a text input called "input"
  function enable_input() {
      document.getElementById("input").disabled = false;
      document.getElementById("input").placeholder = "Message";
  }
  // A callback for when our connection is established.
  function connected_callback(event) {
      enable_input();
      print2output("System: " + client.nickname + ", welcome to the chatroom.");
  }
  // creating the client object and connecting
  function connect2chat(nickname) {
      // create a global client object. The default connection URL is the same as our Controller's URL.
      // the optional PleziClient uses a Websocket connection with automated JSON event routing (auto-dispatch).
      client = new PleziClient();
      // save the nickname
      client.nickname = nickname;
      // Set automatic reconnection. This is great when a laptop or mobile phone is closed.
      client.autoreconnect = true
      // handle connection state updates
      client.onopen = function(event) {
          client.was_closed = false;
          // when the connection opens, we will authenticate with our nickname.
          // This isn't really authenticating anything, but we can add security logic later.
          client.emit({
              event: "chat_auth",
              nickname: client.nickname
          }, connected_callback);
      };
      // handle connection state updates
      client.onclose = function(event) {
          if (client.was_closed) return;
          print2output("System: Connection Lost.");
          client.was_closed = true;
          disable_input();
      };
      // handle the chat_message event
      client.chat_message = function(event) {
          if(client.user_id == event.user_id)
            event.name = "Me";
          print2output(event.name + ": " + event.message)
      };
      // handle the chat_login event
      client.chat_login = function(event) {
          if(!client.id && client.nickname == event.name)
            client.user_id = event.user_id;
          print2output("System: " + event.name + " logged into the chat.")
      };
      // handle the chat_logout event
      client.chat_logout = function(event) {
          print2output("System: " + event.name + " logged out of the chat.")
      };
      return client;
  }
  // This will be used to send the text in the `input` to the websocket.
  function send_text() {
      // get the text
      var msg = document.getElementById("input").value;
      // clear the input field
      document.getElementById("input").value = '';
      // no client? the text is the nickname.
      if (!client) {
          // connect to the chat
          connect2chat(msg);
          // prevent default action (form submission)
          return false;
      }
      // there is a client, the text is a chat message.
      client.emit({
          event: "chat_message",
          message: msg
      });
      // prevent default action (avoid form submission)
      return false;
  }