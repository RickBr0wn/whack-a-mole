import XCTest
@testable import whack_a_mole

final class AudioManagerTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private let suiteName = "AudioManagerTests"

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: suiteName)
        userDefaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        userDefaults = nil
        super.tearDown()
    }

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

    func test_init_defaultsToNotMuted() {
        XCTAssertFalse(AudioManager.loadIsMuted(userDefaults: userDefaults))
    }

    func test_setMuted_persistsToUserDefaults() async {
        let manager = AudioManager(userDefaults: userDefaults)

        await manager.setMuted(true)

        XCTAssertTrue(AudioManager.loadIsMuted(userDefaults: userDefaults))
    }

    func test_setMuted_false_persistsToUserDefaults() async {
        let manager = AudioManager(userDefaults: userDefaults)
        await manager.setMuted(true)

        await manager.setMuted(false)

        XCTAssertFalse(AudioManager.loadIsMuted(userDefaults: userDefaults))
    }
}
