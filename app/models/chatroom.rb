class Chatroom

  # ROOMID = 11196544
  ROOMID = 11337165

  def self.admin
    u = User.find_by mobile_phone: '18616386886'
    return u.uid
  end

  # {"chatroom"=>{"roomid"=>11196544, "valid"=>true, "announcement"=>nil, "muted"=>false, "name"=>"hg", "broadcasturl"=>nil, "ext"=>"", "creator"=>"589247623"}, "code"=>200}
  def self.create
    NeteaseIM::ChatRoom.create(creator: self.admin, name: 'hg-2')
  end

  def self.get roomid=ROOMID
    NeteaseIM::ChatRoom.get(roomid: roomid)
  end

  def self.request_addr uid
    NeteaseIM::ChatRoom.request_addr(roomid: ROOMID, accid: uid)
  end

  def self.members
    NeteaseIM::ChatRoom.members_by_page(roomid: ROOMID, type: 1, endtime: Time.now.to_i, limit: 100)
  end

end