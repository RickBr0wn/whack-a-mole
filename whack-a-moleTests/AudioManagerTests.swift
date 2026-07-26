import XCTest
@testable import whack_a_mole

final class AudioManagerTests: XCTestCase {

    func test_playWhack_doesNotCrash() async {
        let manager = AudioManager()
        await manager.playWhack()
    }

    func test_playBombExplosion_doesNotCrash() async {
        let manager = AudioManager()
        await manager.playBombExplosion()
    }

    func test_playGameOver_doesNotCrash() async {
        let manager = AudioManager()
        await manager.playGameOver()
    }
}
