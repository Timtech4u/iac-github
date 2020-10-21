data "template_file" "cloud-init" {
  template = file("cloud-init.yml.tmpl")

}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "f1-micro"
  zone         = var.zone

  project = var.project

  tags = ["http-traffic", "ssh-traffic"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // this empty block creates a public IP address
    }
  }

  metadata = {
    name      = "wg"
    user-data = data.template_file.cloud-init.rendered
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

// Locking

terraform {
  backend "gcs" {
    bucket  = var.gcs_bucket_name
    prefix  = "terraform/state"
  }
}