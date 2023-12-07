import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!

    static let shared = AudioRecorder()

    private override init() {
        super.init()
        Task { await checkForRecordPermission() }
    }

    func checkForRecordPermission() async {
        if await AVAudioApplication.requestRecordPermission() {
            isAudioRecordingGranted = true
        } else {
            isAudioRecordingGranted = false
        }
    }

    func setupRecorder() {
        if isAudioRecordingGranted {
            recordingSession = AVAudioSession.sharedInstance()
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
            } catch {
                print("error setting up audio recorder", error.localizedDescription)
            }
        }
    }

    func startRecording(fileName: String) {
        let audioFileName = getDocumentsURL().appendingPathComponent(fileName + ".m4a", isDirectory: false)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            print("Error recording ", error.localizedDescription)
            finishRecording()
        }
    }

    func finishRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
}
