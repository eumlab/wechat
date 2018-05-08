require 'spec_helper'

RSpec.describe Wechat::WorkApi do
  let(:token_file) { Rails.root.join('tmp/access_token') }
  let(:jsapi_ticket_file) { Rails.root.join('tmp/jsapi_ticket') }
  let(:result) { { errcode: 0, errmsg: 'ok' } }

  subject do
    Wechat::WorkApi.new('corpid', 'corpsecret', token_file, '1', 20, false, jsapi_ticket_file)
  end

  before :each do
    allow(subject.access_token).to receive(:token).and_return('access_token')
  end

  describe '#API_BASE' do
    specify 'will get correct API_BASE' do
      expect(subject.client.base).to eq Wechat::WorkApi::API_BASE
    end
  end

  describe '#agent_list' do
    specify 'will get user/get with access_token and userid' do
      expect(subject.client).to receive(:get)
        .with('agent/list', params: { access_token: 'access_token' }).and_return(result)
      expect(subject.agent_list).to eq result
    end
  end

  describe '#agent' do
    specify 'will get user/get with access_token and userid' do
      agentid = '1'
      expect(subject.client).to receive(:get)
        .with('agent/get', params: { agentid: agentid, access_token: 'access_token' }).and_return(result)
      expect(subject.agent(agentid)).to eq result
    end
  end

  describe '#user' do
    specify 'will get user/get with access_token and userid' do
      userid = 'userid'
      expect(subject.client).to receive(:get)
        .with('user/get', params: { userid: userid, access_token: 'access_token' }).and_return(result)
      expect(subject.user(userid)).to eq result
    end
  end

  describe '#getuserinfo' do
    specify 'will get user/getuserinfo with access_token and code' do
      code = 'code'
      expect(subject.client).to receive(:get)
        .with('user/getuserinfo', params: { code: code, access_token: 'access_token' }).and_return(result)
      expect(subject.getuserinfo(code)).to eq result
    end
  end

  describe '#convert_to_openid' do
    specify 'will get invite/send with access_token and json userid' do
      userid = 'userid'
      agentid = '1'
      convert_to_openid_request = { userid: userid, agentid: agentid }
      expect(subject.client).to receive(:post)
        .with('user/convert_to_openid', convert_to_openid_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.convert_to_openid(userid)).to eq result
    end
  end

  describe '#user_auth_success' do
    specify 'will get user/authsucc with access_token and userid' do
      userid = 'userid'
      expect(subject.client).to receive(:get)
        .with('user/authsucc', params: { userid: userid, access_token: 'access_token' }).and_return(result)
      expect(subject.user_auth_success(userid)).to eq result
    end
  end

  describe '#user_create' do
    specify 'will create user with access_token and payload position' do
      userid = 'userid'
      create_user_request = { userid: userid,
                              name: '张三',
                              department: [1, 2],
                              mobile: '13901234567',
                              position: '产品经理' }
      expect(subject.client).to receive(:post)
        .with('user/create', create_user_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.user_create(userid: userid, name: '张三', department: [1, 2], mobile: '13901234567', position: '产品经理')).to eq result
    end
  end

  describe '#user_delete' do
    specify 'will get user/delete with access_token and userid' do
      userid = 'userid'
      expect(subject.client).to receive(:get)
        .with('user/delete', params: { userid: userid, access_token: 'access_token' }).and_return(result)
      expect(subject.user_delete(userid)).to eq result
    end
  end

  describe '#user_batchdelete' do
    specify 'will get user/delete with access_token and userid' do
      batchdelete_request = { useridlist: %w(6749 6110) }
      expect(subject.client).to receive(:post)
        .with('user/batchdelete', batchdelete_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.user_batchdelete(%w(6749 6110))).to eq result
    end
  end

  describe '#department_create' do
    specify 'will post department/create with access_token and new department payload' do
      department_create_request = { name: '广州研发中心', parentid: '1' }
      expect(subject.client).to receive(:post)
        .with('department/create', department_create_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.department_create('广州研发中心', '1')).to eq result
    end
  end

  describe '#department_delete' do
    specify 'will get department/delete with access_token and id' do
      departmentid = 'departmentid'
      expect(subject.client).to receive(:get)
        .with('department/delete', params: { access_token: 'access_token', id: departmentid }).and_return(result)
      expect(subject.department_delete('departmentid')).to eq result
    end
  end

  describe '#department_update' do
    specify 'will post department/update with access_token and id' do
      departmentid = 'departmentid'
      department_update_request = { id: departmentid, name: '广研' }
      expect(subject.client).to receive(:post)
        .with('department/update', department_update_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.department_update('departmentid', '广研')).to eq result
    end
  end

  describe '#department' do
    specify 'will get user/get with access_token and userid' do
      departmentid = 'departmentid'
      expect(subject.client).to receive(:get)
        .with('department/list', params: { id: departmentid, access_token: 'access_token' }).and_return(result)
      expect(subject.department(departmentid)).to eq result
    end
  end

  describe '#user_simplelist' do
    specify 'will get user/simplelist with access_token and departmentid' do
      department_id = 'department_id'
      expect(subject.client).to receive(:get)
        .with('user/simplelist', params: { department_id: department_id, fetch_child: 0, access_token: 'access_token' })
        .and_return(result)
      expect(subject.user_simplelist(department_id)).to eq result
    end
  end

  describe '#user_list' do
    specify 'will get user/list with access_token and departmentid' do
      expect(subject.client).to receive(:get)
        .with('user/list', params: { department_id: 1, fetch_child: 0, access_token: 'access_token' }).and_return(result)
      expect(subject.user_list(1)).to eq result
    end
  end

  describe '#tag_create' do
    specify 'will post tag/create with access_token and new department payload' do
      tag_create_request = { tagname: 'UI', tagid: 1 }
      expect(subject.client).to receive(:post)
        .with('tag/create', tag_create_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_create('UI', 1)).to eq result
    end
  end

  describe '#tag_update' do
    specify 'will post tag/update with access_token and new department payload' do
      tag_update_request = { tagid: 1, tagname: 'UI Design' }
      expect(subject.client).to receive(:post)
        .with('tag/update', tag_update_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_update(1, 'UI Design')).to eq result
    end
  end

  describe '#tag_delete' do
    specify 'will get tag/delete with access_token and tagid' do
      expect(subject.client).to receive(:get)
        .with('tag/delete', params: { tagid: 1, access_token: 'access_token' }).and_return(result)
      expect(subject.tag_delete(1)).to eq result
    end
  end

  describe '#tags' do
    specify 'will get tag/list with access_token' do
      expect(subject.client).to receive(:get)
        .with('tag/list', params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tags).to eq result
    end
  end

  describe '#tag' do
    specify 'will get user/get with access_token and tagid' do
      expect(subject.client).to receive(:get)
        .with('tag/get', params: { tagid: 1, access_token: 'access_token' }).and_return(result)
      expect(subject.tag(1)).to eq result
    end
  end

  describe '#tag_add_user' do
    specify 'will post tag/addtagusers with tagid, userlist(userids) and access_token' do
      tag_add_user_request = { tagid: 1, userlist: %w(6749 6110), partylist: nil }
      expect(subject.client).to receive(:post)
        .with('tag/addtagusers', tag_add_user_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_add_user(1, %w(6749 6110))).to eq result
    end

    specify 'will post tag/addtagusers with tagid, partylist(departmentids) and access_token' do
      tag_add_party_request = { tagid: 1, userlist: nil, partylist: [1, 2] }
      expect(subject.client).to receive(:post)
        .with('tag/addtagusers', tag_add_party_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_add_user(1, nil, [1, 2])).to eq result
    end
  end

  describe '#tag_del_user' do
    specify 'will post tag/deltagusers with tagid, userlist(userids) and access_token' do
      tag_del_user_request = { tagid: 1, userlist: %w(6749 6110), partylist: nil }
      expect(subject.client).to receive(:post)
        .with('tag/deltagusers', tag_del_user_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_del_user(1, %w(6749 6110))).to eq result
    end

    specify 'will post tag/deltagusers with tagid, partylist(departmentids) and access_token' do
      tag_del_party_request = { tagid: 1, userlist: nil, partylist: [1, 2] }
      expect(subject.client).to receive(:post)
        .with('tag/deltagusers', tag_del_party_request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.tag_del_user(1, nil, [1, 2])).to eq result
    end
  end

  describe '#menu' do
    specify 'will get menu/get with access_token and agentid' do
      expect(subject.client).to receive(:get).with('menu/get', params: { access_token: 'access_token', agentid: '1' }).and_return(result)
      expect(subject.menu).to eq(result)
    end
  end

  describe '#menu_delete' do
    specify 'will get menu/delete with access_token and agentid' do
      expect(subject.client).to receive(:get).with('menu/delete', params: { access_token: 'access_token', agentid: '1' }).and_return(true)
      expect(subject.menu_delete).to be true
    end
  end

  describe '#menu_create' do
    specify 'will post menu/create with access_token, agentid and json_data' do
      menu = { buttons: ['a_button'] }
      expect(subject.client).to receive(:post)
        .with('menu/create', menu.to_json, params: { access_token: 'access_token', agentid: '1' }).and_return(true)
      expect(subject.menu_create(menu)).to be true
    end
  end

  describe '#message_send' do
    specify 'will post message with access_token, and json payload' do
      payload = {
        touser: 'userid',
        msgtype: 'text',
        agentid: '1',
        text: { content: 'message content' }
      }

      expect(subject.client).to receive(:post)
        .with('message/send', payload.to_json,
              content_type: :json, params: { access_token: 'access_token' }).and_return(true)
      expect(subject.message_send('userid', 'message content')).to be true
    end
  end

  describe '#custom_message_send' do
    specify 'will post message/send with access_token, and json payload' do
      payload = {
        touser: 'openid',
        msgtype: 'text',
        agentid: '1',
        text: { content: 'message content' }
      }

      expect(subject.client).to receive(:post)
        .with('message/send', payload.to_json, params: { access_token: 'access_token' }, content_type: :json)
        .and_return(true)
      expect(subject.custom_message_send(Wechat::Message.to('openid').text('message content'))).to be true
    end
  end

  describe '#chat_create' do
    specify 'will get menu/get with access_token and agentid' do
      request = { name: 'test', owner: 'owner', userlist: %w(6749 6110), chatid: 'chatid' }
      expect(subject.client).to receive(:post).with('appchat/create', request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.chat_create(request)).to eq(result)
    end
  end

  describe '#chat_update' do
    specify 'will get menu/get with access_token and agentid' do
      request = { chatid: 'chatid', name: 'test', owner: 'owner' }
      expect(subject.client).to receive(:post).with('appchat/update', request.to_json, params: { access_token: 'access_token' }).and_return(result)
      expect(subject.chat_update('chatid', 'test', 'owner')).to eq(result)
    end
  end

  describe '#chat' do
    specify 'will get menu/get with access_token and agentid' do
      expect(subject.client).to receive(:get).with('appchat/get', params: { access_token: 'access_token', chatid: 'chatid' }).and_return(result)
      expect(subject.chat('chatid')).to eq(result)
    end
  end

  describe '#chat_send' do
    specify 'will post message with access_token, and json payload' do
      payload = {
        chatid: 'chatid',
        msgtype: 'text',
        text: { content: 'message content' }
      }

      expect(subject.client).to receive(:post)
        .with('appchat/send', payload.to_json,
              content_type: :json, params: { access_token: 'access_token' }).and_return(true)
      expect(subject.chat_send('chatid', 'message content')).to be true
    end
  end

  describe '#custom_chat_send' do
    specify 'will post message/send with access_token, and json payload' do
      payload = {
        chatid: 'chatid',
        msgtype: 'text',
        text: { content: 'message content' }
      }

      expect(subject.client).to receive(:post)
        .with('appchat/send', payload.to_json, params: { access_token: 'access_token' }, content_type: :json)
        .and_return(true)
      expect(subject.custom_chat_send(Wechat::Message.to_chat('chatid').text('message content'))).to be true
    end
  end
end
