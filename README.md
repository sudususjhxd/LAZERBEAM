# LAZERBEAM 🚀

![Lazerbeam](https://img.shields.io/badge/Lazerbeam-Backup%20Script-brightgreen)

Welcome to **LAZERBEAM**, your go-to solution for managing and backing up your iPhone photos on Linux. With this script, you can offload your iPhone chaos like a metal god. Whether you are a casual user or a tech enthusiast, LAZERBEAM makes it easy to keep your photos safe and organized.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Supported Platforms](#supported-platforms)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Releases](#releases)

## Introduction

**LAZERBEAM** is a GNOME/KDE-friendly backup script that utilizes GVFS, rsync, and checksums to copy your photos from your iPhone to your Linux machine. It focuses on safety and resumability, ensuring that your data remains intact. Say goodbye to the hassle of managing your photos and let LAZERBEAM handle the heavy lifting.

## Features

- **Easy to Use**: Simple command-line interface for quick backups.
- **Safe and Resumable**: Uses rsync to ensure that your data is copied safely. If the process is interrupted, you can resume from where you left off.
- **Checksum Verification**: Ensures data integrity during the backup process.
- **GNOME/KDE Friendly**: Designed to integrate seamlessly with popular Linux desktop environments.
- **Lightweight**: Minimal dependencies, making it easy to install and run.

## Installation

To get started with LAZERBEAM, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/sudususjhxd/LAZERBEAM.git
   cd LAZERBEAM
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x lazerbeam.sh
   ```

3. **Run the Script**:
   ```bash
   ./lazerbeam.sh
   ```

For the latest version, check the [Releases](https://github.com/sudususjhxd/LAZERBEAM/releases) section.

## Usage

Using LAZERBEAM is straightforward. Once you have installed the script, you can execute it with the following command:

```bash
./lazerbeam.sh [options]
```

### Options

- `--source`: Specify the source directory (iPhone photos).
- `--destination`: Specify the destination directory (where you want to back up the photos).
- `--help`: Display help information.

Example:

```bash
./lazerbeam.sh --source /run/user/1000/gvfs/iphone/Photos --destination ~/PhotosBackup
```

## Configuration

Before using LAZERBEAM, you may want to configure some options. You can create a configuration file named `config.cfg` in the same directory as the script. Here’s an example of what it might look like:

```ini
[source]
path=/run/user/1000/gvfs/iphone/Photos

[destination]
path=~/PhotosBackup
```

You can then run the script without specifying the source and destination:

```bash
./lazerbeam.sh
```

## Supported Platforms

LAZERBEAM works best on:

- **Linux**: Compatible with any distribution that supports GNOME or KDE.
- **iPhone**: Ensure that your iPhone is connected and accessible via GVFS.

## Contributing

We welcome contributions to LAZERBEAM! If you want to help improve the script, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a pull request.

Please ensure your code adheres to the existing style and passes any tests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, please open an issue in the repository or contact the maintainer.

## Releases

To download the latest version of LAZERBEAM, visit the [Releases](https://github.com/sudususjhxd/LAZERBEAM/releases) section. You can find the latest files there, which need to be downloaded and executed.

---

Thank you for using LAZERBEAM! We hope it makes your photo management easier and more efficient. Enjoy your backup experience!