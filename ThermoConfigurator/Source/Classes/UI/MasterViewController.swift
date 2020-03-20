//
//  MasterViewController.swift
//  ThermoConfigurator
//
//  Created by Thomas Bonk on 20.03.20.
//  Copyright © 2020 Thomas Bonk. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, NetServiceBrowserDelegate, NetServiceDelegate {

    /// MARK: - Properties

    var detailViewController: DetailViewController? = nil
    var bonjourBrowser = NetServiceBrowser()
    var services = [NetService]()


    /// MARK: - UITableViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        bonjourBrowser.delegate = self

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)

        bonjourBrowser.searchForServices(ofType: "_smrtthrm._tcp.", inDomain: "local.")
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let service = services[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController

                controller.detailItem = service
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }


    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = services[indexPath.row].name
        cell.detailTextLabel!.text = services[indexPath.row].ipAddress
        return cell
    }


    /// MARK: - NetServiceBrowserDelegate

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        services.append(service)

        DispatchQueue.main.async {
            self.tableView.reloadData()

            DispatchQueue.main.async {
                service.delegate = self
                service.resolve(withTimeout: 30)
            }
        }
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        service.delegate = nil

        if let index = services.firstIndex(of: service) {
            services.remove(at: index)
            self.tableView.reloadData()
        }
    }


    /// MARK: - NetServiceDelegate

    func netServiceDidResolveAddress(_ service: NetService) {
        self.tableView.reloadData()
    }
}

