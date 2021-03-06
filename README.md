# CAPTCHA Warrior
Elegant CAPTCHA breaker based on Computer Vision

## Getting Started

### Prerequisites
- Matlab 9.2.0 or above
- Matlab computer vision toolbox

### Usage

## Contributing
When contributing to this repository, please first discuss the change you wish to make via issue, email, or Facebook group chat with the owners of this repository before making a change.

1. Ensure any install or build dependencies are removed before the end of the layer when doing a build.

2. Update the README.md with details of changes to the interface, this includes new environment variables, exposed ports, useful file locations and container parameters.

3. Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent. The versioning scheme we use is SemVer.

4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

## Dataset Generation
- Dependencies
-- Pillow
-- Flask

- Execution
1. Open DatasetGenerator.py
2. Modify the DATA_SIZE parameter to desired number of images
3. Create images directory
4. Run DatasetGenerator.py
5. The images directory will contain CAPTCHA images and hash_to_label.csv contains the ground truth label of each image.

## Authors

- **Shaoju Wu** - *Initial work* - [wushaoju](https://github.com/wushaoju)

- **Sai Kiran Vadlamudi** - *Initial work* - [svadlamudi](https://github.com/svadlamudi)

- **Yang Liu** - *Initial work* - [byliuyang](https://github.com/byliuyang)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
