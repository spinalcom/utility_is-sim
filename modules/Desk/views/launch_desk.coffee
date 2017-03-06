#clear page
USER_EMAIL = ""
USER = {}
HOME_DIR=""

disconnect = (error)->
  if config.user
    delete config.user;
  if config.password
    delete config.password;
  localStorage.removeItem('spinal_user_connect');
  if error
    window.location = "login-dashboard.html#error";
  else
    window.location = "login-dashboard.html";

get_user_local = ()->
  user_str;
  if (parseInt(window.location.port) == parseInt(config.admin_port))
    user_str = localStorage.getItem('spinal_user_connect');
  else
    user_str = localStorage.getItem('spinal_connect');
  if (user_str)
    user = JSON.parse(user_str);
    config.user = user.user;
    config.password = user.password;


load_if_cookie_desk = () ->

  get_user_local();
  if (!config.user || !config.password)
    window.location = "login-dashboard.html";
  else
    SpinalUserManager.get_user_id("http://" + config.host + ":" + config.user_port + "/", config.user, config.password, (response)=>
      config.user_id = parseInt(response);
      HOME_DIR = "__users__/#{config.user}"
      USER.userid = config.user_id
      USER.password = config.password
      launch_desk();
    , (err)->
      disconnect();
    );
#
#
# load_if_cookie_desk = () ->
#     if Cookies.set("email") and Cookies.set("password")
#         email = Cookies.set("email")
#         password = Cookies.set("password")
#         USER_EMAIL = email
#
#         xhr_object = FileSystem._my_xml_http_request()
#         xhr_object.open 'GET', "../get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
#         xhr_object.onreadystatechange = ->
#             if @readyState == 4 and @status == 200
#                 lst = @responseText.split " "
#                 user_id = parseInt lst[ 0 ]
#                 if user_id > 0
#                     launch_desk user_id, decodeURIComponent lst[ 1 ].trim()
#                 else
#                      window.location = "login.html"
#
#
#         xhr_object.send()
#
#     else
#         window.location = "login.html"
#

# launch_desk = ( userid, home_dir, main = document.body ) ->
launch_desk = ( main = document.body ) ->
    MAIN_DIV = main

    #load or create config file
    FileSystem._home_dir = HOME_DIR
    FileSystem._userid   = if USER?.userid then USER.userid else "1657"
    FileSystem._password = if USER?.password then USER.password else "4YCSeYUzsDG8XSrjqXgkDPrdmJ3fQqHs"
    bs = new BrowserState
    fs = new FileSystem
    config_dir = FileSystem._home_dir + "/__config__"

    fs.load_or_make_dir config_dir, ( current_dir, err ) ->
        config_file = current_dir.detect ( x ) -> x.name.get() == ".config"
        if not config_file?
            config  = new DeskConfig
            current_dir.add_file ".config", config, model_type: "Config"
            create_desk_view config, main

        else
            config_file.load ( config, err ) =>
                create_desk_view config, main


create_desk_view = ( config, main = document.body ) ->
    #login bar
    login_bar = new LoginBar main, config

    #desk
    dd = new DeskData  config
    app = new DeskApp main, dd
