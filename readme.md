# Audio File Format Converter

## Converts audio files to a specified format using ffmpeg.

### Created By Damon Murdoch ([@SirScrubbington](https://github.com/SirScrubbington))

## Description

This PowerShell script converts audio files from one format to another using ffmpeg. It supports processing files in a specified directory or recursively in subdirectories. The output files are saved in the specified output directory with the desired format. If the output directory doesn't exist, it will be created. Optionally, it can compare the sizes of the input and output directories to check for any differences after conversion. Please note that ffmpeg is required to be installed to use this script. You can choose to simply add the ffmpeg.exe binary file in the same directory as this script. For installation instructions, please see [FFmpeg Builds by Gyan](https://www.gyan.dev/ffmpeg/builds/).

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Future Changes](#future-changes)
- [Problems / Improvements](#problems--improvements)
- [Changelog](#changelog)
- [Sponsor this Project](#sponsor-this-project)
- [License](#license)

## Installation

1. Ensure you have ffmpeg installed. If not, download the binary from [FFmpeg Builds by Gyan](https://www.gyan.dev/ffmpeg/builds/) and place it in the same directory as the script.
2. Download the script file (`Convert-AudioFileFormat.ps1`) from the repository.

## Usage

Run the script from the PowerShell terminal with appropriate parameters.

```powershell
.\Convert-AudioFileFormat.ps1 -InputPath "C:\Audio" -OutputPath "D:\ConvertedAudio" -OutputFormat ".mp3" -Recurse
```

This command converts all audio files in the "C:\Audio" directory and its subdirectories to the .mp3 format and saves them in the "D:\ConvertedAudio" directory.

```powershell
.\Convert-AudioFileFormat.ps1 -InputPath "C:\Audio" -OutputPath "D:\ConvertedAudio" -OutputFormat ".wav" -Recurse -Compare
```

This command converts all audio files in the "C:\Audio" directory and its subdirectories to the .wav format, saves them in the "D:\ConvertedAudio" directory, and compares the sizes of input and output directories after conversion.

## Future Changes

- Implement support for additional audio formats.
- Enhance error handling and logging functionalities.

### Change Table

| Change Description                           | Priority |
| -------------------------------------------- | -------- |
| Support for additional audio formats         | High     |
| Improve error handling and logging features   | Medium   |

## Problems / Improvements

If you encounter any issues or have suggestions for improvements, please [open an issue](../../issues) or send a message to [@SirScrubbington](https://github.com/SirScrubbington).

## Changelog

### Ver. 1.0.0

- Initial release of the audio file format converter script.

## Sponsor this Project

If you'd like to support this project and other future projects, you can sponsor me through PayPal: [Sponsor Link](https://www.paypal.com/paypalme/sirsc)

## License

This project is licensed under the [MIT License](LICENSE).