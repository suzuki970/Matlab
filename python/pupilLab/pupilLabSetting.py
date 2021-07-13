
def pick_ch_names(info):
    ch_xml = info.desc().child('channels').child('channel')
    ch_names = []
    for _ in range(info.channel_count()):
        ch_names.append(ch_xml.child_value('label'))
        ch_xml = ch_xml.next_sibling()
    return ch_names
