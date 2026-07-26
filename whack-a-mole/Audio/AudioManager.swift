import AVFoundation

actor AudioManager {
    private var whackPlayer: AVAudioPlayer?
    private var bombExplosionPlayer: AVAudioPlayer?
    private var gameOverPlayer: AVAudioPlayer?

    init() {
        whackPlayer = Self.loadPlayer(named: "whack")
        bombExplosionPlayer = Self.loadPlayer(named: "bomb_explosion")
        gameOverPlayer = Self.loadPlayer(named: "game_over")
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
        guard let player else { return }
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
}
