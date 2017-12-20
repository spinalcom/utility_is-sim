#clear page
MAIN_DIV = document.body
USER = {}
HOME_DIR=""
clear_page = ->
    while MAIN_DIV.firstChild?
        MAIN_DIV.removeChild MAIN_DIV.firstChild

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


load_if_cookie_lab = () ->

  get_user_local();
  if (!config.user || !config.password)
    window.location = "login-dashboard.html";
  else
    SpinalUserManager.get_user_id("http://" + config.host + ":" + config.user_port + "/", config.user, config.password, (response)=>
      config.user_id = parseInt(response);
      HOME_DIR = "__users__/#{config.user}"
      USER.userid = config.user_id
      USER.password = config.password
      launch_lab();
    , (err)->
      disconnect();
    );

    # if Cookies.set("email") and Cookies.set("password")
    #     email = Cookies.set("email")
    #     password = Cookies.set("password")
    #     USER_EMAIL = email
    #
    #     xhr_object = FileSystem._my_xml_http_request()
    #     xhr_object.open 'GET', "../get_user_id?u=#{encodeURI email}&p=#{encodeURI password}", true
    #     xhr_object.onreadystatechange = ->
    #         if @readyState == 4 and @status == 200
    #             lst = @responseText.split " "
    #             user_id = parseInt lst[ 0 ]
    #             if user_id > 0
    #                 launch_lab user_id, decodeURIComponent lst[ 1 ].trim()
    #             else
    #                  window.location = "login.html"
    #
    #
    #     xhr_object.send()
    #
    # else
    #     window.location = "login.html"


#main program
# launch_lab = ( userid, home_dir, main = document.body ) ->
launch_lab = ( main = document.body ) ->
    FileSystem._home_dir = HOME_DIR
    FileSystem._userid   = if USER?.userid then USER.userid else "1657"
    FileSystem._password = if USER?.password then USER.password else "4YCSeYUzsDG8XSrjqXgkDPrdmJ3fQqHs"
    MAIN_DIV = main


    #lab
    bs = new BrowserState
    fs = new FileSystem

    bs.location.bind ->
        clear_page()


        #login bar
        config_dir = FileSystem._home_dir + "/__config__"
        fs.load_or_make_dir config_dir, ( current_dir, err ) ->
          config_file = current_dir.detect ( x ) -> x.name.get() == ".config"
          if not config_file?
            config  = new DeskConfig
            current_dir.add_file ".config", config, model_type: "Config"
            login_bar = new LoginBar main, config
          else
            config_file.load ( config, err ) ->
              login_bar = new LoginBar main, config

        hash = bs.location.hash.get()
        # something to reload ?
        if hash.length > 1
            hash = hash.slice 1
            path = decodeURIComponent hash
            fs.load path, ( td, err ) ->
                if err
                    # window.location = "#"
                    # test if file exists
                    dir_path = hash.replace(/\/[^\/]+$/, '')
                    fs.load dir_path, ( _td, _err ) ->
                        if _err
                            window.location = "#"
                        else
                            nameArray = hash.split('/')
                            filename = nameArray[nameArray.length - 1]
                            file = _td.find(filename)
                            if file
                                tap = new TreeAppData
                                tap.new_session()
                                tap.modules.push new TreeAppModule_UndoManager
                                tap.modules.push new TreeAppModule_PanelManager
                                tap.modules.push new TreeAppModule_File
                                tap.modules.push new TreeAppModule_Apps
                                tap.modules.push new TreeAppModule_Animation
                                tap.modules.push new TreeAppModule_TreeView
                                file._ptr.set(tap)
                                app = new TreeApp main, tap
                else
                    app = new TreeApp main, td

                    # visualisation
                    # fs.load_or_make_dir "/sessions/" + fs._session_num, ( session_dir, err ) ->
                    #     session_dir.add_file "server_assisted_visualization", new ServerAssistedVisualization app, bs

        # else, return to desk
        else
            window.location = "desk.html"
