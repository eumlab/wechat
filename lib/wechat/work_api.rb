require 'wechat/api_base'
require 'wechat/http_client'
require 'wechat/token/corp_access_token'
require 'wechat/ticket/corp_jsapi_ticket'

module Wechat
  class WorkApi < ApiBase
    attr_reader :agentid

    API_BASE = 'https://qyapi.weixin.qq.com/cgi-bin/'.freeze

    def initialize(appid, secret, token_file, agentid, timeout, skip_verify_ssl, jsapi_ticket_file)
      @client = HttpClient.new(API_BASE, timeout, skip_verify_ssl)
      @access_token = Token::CorpAccessToken.new(@client, appid, secret, token_file)
      @agentid = agentid
      @jsapi_ticket = Ticket::CorpJsapiTicket.new(@client, @access_token, jsapi_ticket_file)
    end

    def agent_list
      get 'agent/list'
    end

    def agent(agentid)
      get 'agent/get', params: { agentid: agentid }
    end

    def user(userid)
      get 'user/get', params: { userid: userid }
    end

    def getuserinfo(code)
      get 'user/getuserinfo', params: { code: code }
    end

    def convert_to_openid(userid)
      post 'user/convert_to_openid', JSON.generate(userid: userid, agentid: agentid)
    end

    def user_auth_success(userid)
      get 'user/authsucc', params: { userid: userid }
    end

    def user_create(user)
      post 'user/create', JSON.generate(user)
    end

    def user_delete(userid)
      get 'user/delete', params: { userid: userid }
    end

    def user_batchdelete(useridlist)
      post 'user/batchdelete', JSON.generate(useridlist: useridlist)
    end

    def department_create(name, parentid)
      post 'department/create', JSON.generate(name: name, parentid: parentid)
    end

    def department_delete(departmentid)
      get 'department/delete', params: { id: departmentid }
    end

    def department_update(departmentid, name = nil, parentid = nil, order = nil)
      post 'department/update', JSON.generate({ id: departmentid, name: name, parentid: parentid, order: order }.reject { |_k, v| v.nil? })
    end

    def department(departmentid = 1)
      get 'department/list', params: { id: departmentid }
    end

    def user_simplelist(department_id, fetch_child = 0)
      get 'user/simplelist', params: { department_id: department_id, fetch_child: fetch_child }
    end

    def user_list(department_id, fetch_child = 0)
      get 'user/list', params: { department_id: department_id, fetch_child: fetch_child }
    end

    def tag_create(tagname, tagid = nil)
      post 'tag/create', JSON.generate(tagname: tagname, tagid: tagid)
    end

    def tag_update(tagid, tagname)
      post 'tag/update', JSON.generate(tagid: tagid, tagname: tagname)
    end

    def tag_delete(tagid)
      get 'tag/delete', params: { tagid: tagid }
    end

    def tags
      get 'tag/list'
    end

    def tag(tagid)
      get 'tag/get', params: { tagid: tagid }
    end

    def tag_add_user(tagid, userids = nil, departmentids = nil)
      post 'tag/addtagusers', JSON.generate(tagid: tagid, userlist: userids, partylist: departmentids)
    end

    def tag_del_user(tagid, userids = nil, departmentids = nil)
      post 'tag/deltagusers', JSON.generate(tagid: tagid, userlist: userids, partylist: departmentids)
    end

    def menu
      get 'menu/get', params: { agentid: agentid }
    end

    def menu_delete
      get 'menu/delete', params: { agentid: agentid }
    end

    def menu_create(menu)
      # 微信不接受7bit escaped json(eg \uxxxx), 中文必须UTF-8编码, 这可能是个安全漏洞
      post 'menu/create', JSON.generate(menu), params: { agentid: agentid }
    end

    def message_send(userid, message)
      post 'message/send', Message.to(userid).text(message).agent_id(agentid).to_json, content_type: :json
    end

    def custom_message_send(message)
      post 'message/send', message.agent_id(agentid).to_json, content_type: :json
    end

    def chat_create(chat)
      post 'appchat/create', JSON.generate(chat)
    end

    def chat_update(chatid, name, owner)
      post 'appchat/update', JSON.generate(chatid: chatid, name: name, owner: owner)
    end

    def chat(chatid)
      get 'appchat/get', params: { chatid: chatid }
    end

    def chat_send(chatid, message)
      post 'appchat/send', Message.to_chat(chatid).text(message).to_json, content_type: :json
    end

    def custom_chat_send(message)
      post 'appchat/send', message.to_json, content_type: :json
    end
  end
end
