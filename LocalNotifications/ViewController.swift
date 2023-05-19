import UserNotifications
import UIKit

class ViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        UNUserNotificationCenter.current().delegate = self
    }

    @IBAction func didTapButton(sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: {(success) in
                    guard success else { return }
                    self.scheduleLocalNotification()
                })

            case .authorized:
                self.scheduleLocalNotification()

            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                print("Application Not Allowed to Display Notifications")
            case .ephemeral:
                print("Application Not Allowed to Display Notifications")
            @unknown default:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }

    private func requestAuthorization(completionHandler: @escaping(_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("request authorization failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }

    private func scheduleLocalNotification() {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "Cocoacasts"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "In this tutorial, you learn how to schedule local notification with the use of User Notifications Framework"

        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)

        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)

        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let error = error {
                print("unable to add notifiation request (\(error), \(error.localizedDescription))")
            }
        }
    }

}


extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
