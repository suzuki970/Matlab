import zmq, msgpack
class PupilLabs:    
    def __init__(self, session_name):

        def send_command(n, socket):
            socket.send_multipart([('notify.%s'%n['subject']).encode('utf-8'), msgpack.dumps(n)])
            return socket.recv()

        self.send_command = send_command
        self.session_name = session_name
        context = zmq.Context()
        self.socket = context.socket(zmq.REQ)
        self.socket.connect('tcp://localhost:50020')

        # EYE CAMERA 1 (/2) ACTIVATE
        n = {'subject': 'eye_process.should_start.0',
             'eye_id' : 0}
        send_command(n, self.socket)

        # EYE CAMERA 2 (/2) INACTIVATE
        n = {'subject': 'eye_process.should_start.0',
             'eye_id' : 1}
        send_command(n, self.socket)

        # START PLUGIN
        n = {'subject': 'start_plugin',
             'name'   : 'Annotation_Capture'}
        send_command(n, self.socket)

    def init_recording(self):
        n = {'subject'     : 'recording.should_start',
             'session_name': self.session_name}
        self.send_command(n, self.socket)

    def stop_recording(self):
        n = {'subject'     : 'recording.should_stop'}
        self.send_command(n, self.socket)

    def send_annotation(self, label):
        self.socket.send_string('t')
        ts = float(self.socket.recv())
        n = {'topic'    : 'annotation',
             'label'    : label,
             'timestamp': ts
             }
        self.socket.send_multipart([(n['topic']).encode('utf-8'), msgpack.dumps(n)])
        self.socket.recv()