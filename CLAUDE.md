# Sandbox-MultiModule

Swift Packageのマルチモジュール構成の研究をするためのリポジトリです。
Hexagonal Architecture（Ports and Adapters）に基づいたパッケージ構成を採用しています。

## バージョン情報

- Xcode 26.2
- Swift 6.2

## パッケージ構成

Sandbox-MultiModule-Library内のパッケージ構成について解説します。
Hexagonal Architectureをベースにしています。

### Domain

ドメインモデルを定義する層。アプリケーション全体で使用するデータモデルを含む。

- **Domain**（Sources/Domain）
  - アプリ全体で使用するデータモデルを定義する
  - 例: `SearchResultItem`, `RepositoryDetail`

### Application

アプリケーションロジック（UseCase）の実装を定義する層。

- **Application**（Sources/Application）
  - UseCaseの実装を定義する
  - DrivingPortで定義されたUseCaseインタフェースに対する`DependencyKey.liveValue`を提供
  - DrivenPortのPortインタフェースを利用してデータを取得

### Port

各層のインタフェース（protocol相当）を定義する層。swift-dependenciesの`@DependencyClient`を使用。

- **DrivingPort**（Sources/Port/Driving）
  - FeatureやApplicationから参照されるUseCaseのインタフェースを定義する
  - `TestDependencyKey.testValue`とDependencyValuesへの登録を含む
  - 例: `SearchRepositoryUseCase`, `RepositoryDetailUseCase`
- **DrivenPort**（Sources/Port/Driven）
  - ApplicationやAdapterから参照されるPortのインタフェースを定義する
  - `TestDependencyKey.testValue`とDependencyValuesへの登録を含む
  - 例: `SearchRepositoryPort`, `GetRepositoryDetailPort`

### Adapter

外部システムとの接続を担うアダプター層。

- **DrivenAdapter**（Sources/Adapter/Driven）
  - 外部API等のデータを取得するPortの実装を定義する
  - DrivenPortで定義されたPortインタフェースに対する`DependencyKey.liveValue`を提供
  - OpenAPI Generatorで自動生成されたAPIクライアントを使用

### DesignSystem

UIを構成するためのデザイントークンやコンポーネントを定義する層。

- **DesignSystem**（Sources/DesignSystem）
  - UIを構成するためのデザイントークンやコンポーネントを定義する

### FeatureBuilder

Feature間の依存関係を解決するためのインタフェースを定義する層。

- **FeatureBuilder**（Sources/FeatureBuilder）
  - Feature間の依存関係を解決するためのViewBuilderインタフェースを定義する
  - 他のFeatureの画面を生成するためのインタフェースを提供
  - `TestDependencyKey.testValue`とDependencyValuesへの登録を含む
  - 例: `SearchRepositoryFeatureBuilder`, `RepositoryDetailFeatureBuilder`

### Feature

アプリの画面（UI/プレゼンテーションロジック）を定義する層。画面ごとにターゲットを分割。

- **SearchRepositoryFeature**（Sources/Feature/SearchRepository）
  - GitHubリポジトリ検索画面
  - FeatureBuilderで定義された`SearchRepositoryFeatureBuilder`に対する`DependencyKey.liveValue`を提供
- **RepositoryDetailFeature**（Sources/Feature/RepositoryDetail）
  - リポジトリ詳細画面
  - FeatureBuilderで定義された`RepositoryDetailFeatureBuilder`に対する`DependencyKey.liveValue`を提供

### Tests

各モジュールのユニットテストを定義する層。

- **ApplicationTests**（Tests/Application）
  - Application層のUseCaseに対するテスト
- **DrivenAdapterTests**（Tests/Adapter/Driven）
  - Adapter層のRepositoryに対するテスト

```mermaid
graph TD
  subgraph Port
    DrivenPort
    DrivingPort
  end
  subgraph Feature
    RepositoryDetailFeature
    SearchRepositoryFeature
  end

  Application --> Domain
  Application --> DrivenPort
  Application --> DrivingPort
  ApplicationTests --> Application
  DrivenAdapter --> Domain
  DrivenAdapter --> DrivenPort
  DrivenAdapterTests --> DrivenAdapter
  DrivenPort --> Domain
  DrivingPort --> Domain
  FeatureBuilder --> Domain
  RepositoryDetailFeature --> DesignSystem
  RepositoryDetailFeature --> Domain
  RepositoryDetailFeature --> DrivingPort
  RepositoryDetailFeature --> FeatureBuilder
  SearchRepositoryFeature --> DesignSystem
  SearchRepositoryFeature --> Domain
  SearchRepositoryFeature --> DrivingPort
  SearchRepositoryFeature --> FeatureBuilder
```
