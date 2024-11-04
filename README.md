# Azure Agents Python Quickstart

# Azure Agents Travel Assistant

This repository contains a sample implementation of an Azure-based travel assistant. The travel assistant leverages Azure Cognitive Services to understand images and documents, providing assistance during travel planning and common travel situations. Key features include:

- **Image Recognition**: Identify landmarks, extract text from travel documents, and more.
- **Document Understanding**: Parse itineraries, booking confirmations, and other travel-related documents.
- **Travel Assistance**: Offer recommendations, reminders, and support for various travel scenarios.

## Getting Started

To get started with the Azure Agents Travel Assistant, follow the instructions below to set up your environment and run the sample application.

### Prerequisites

- An Azure subscription
- Python 3.7 or later
- Azure Cognitive Services API keys

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/azure-agents-travel-assistant.git
    cd azure-agents-travel-assistant
    ```

2. Install the required Python packages:
    ```sh
    pip install -r requirements.txt
    ```

3. Set up your Azure Cognitive Services keys:
    ```sh
    export AZURE_COGNITIVE_SERVICES_KEY=<your_key>
    export AZURE_COGNITIVE_SERVICES_ENDPOINT=<your_endpoint>
    ```

### Running the Sample

Run the travel assistant application:
```sh
python travel_assistant.py
```

For detailed instructions and additional configuration options, refer to the [documentation](docs/README.md).


## How to Contribute

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq) or contact <opencode@microsoft.com> with any additional questions or comments.

## Key Contacts & Contributors

| Contact | GitHub ID | Email |
|---------|-----------|-------|
| Marco Cardoso | @MarcoABCardoso | macardoso@microsoft.com |

## License

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.


---

This project is part of the AI-in-a-Box series, aimed at providing the technical community with tools and accelerators to implement AI/ML solutions efficiently and effectively.
