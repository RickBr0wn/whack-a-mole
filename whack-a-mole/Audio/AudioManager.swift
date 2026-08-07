import AVFoundation

actor AudioManager {
    private static let isMutedKey = "isSoundMuted"

    private var whackPlayer: AVAudioPlayer?
    private var bombExplosionPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?
    private var isMuted: Bool
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.isMuted = userDefaults.bool(forKey: Self.isMutedKey)
        whackPlayer = Self.loadPlayer(named: "whack")
        bombExplosionPlayer = Self.loadPlayer(named: "bomb_explosion")
        gameOverPlayer = Self.loadPlayer(named: "game_over")
    }

    func setMuted(_ muted: Bool) {
        isMuted = muted
        userDefaults.set(muted, forKey: Self.isMutedKey)
    }

    func playWhack() {
        play(whackPlayer)
    }

    func playBombExplosion() {
        play(bombExplosionPlayer)
    }

    func playGameOver() {
        play(gameOverPlayer)
    }

    private func play(_ player: AVAudioPlayer?) {
        guard !isMuted, let player else { return }
        player.stop()
        player.currentTime = 0
        player.play()
    }

    private static func loadPlayer(named name: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            return nil
        }
        return try? AVAudioPlayer(contentsOf: url)
    }

    nonisolated static func loadIsMuted(userDefaults: UserDefaults = .standard) -> Bool {
        userDefaults.bool(forKey: isMutedKey)
    }
}
