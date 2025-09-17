# Morpheus Perseids API

This project provides a Dockerized API interface for the [Alatius' version](https://github.com/whothefluff/morpheus-alatius-xml) of the Morpheus morphological parsing tool. It is an adapted fork of the original [Morpheus Perseids API](https://github.com/perseids-tools/morpheus-perseids-api).

It takes Ancient Greek or Latin text as input and then lemmatizes the text and performs a morphological analysis.

## Running with Docker (Recommended)

The recommended way to run this project is with Docker and Docker Compose. This handles all dependencies and provides a consistent environment.

### 1. Prerequisites

- A working installation of **Docker**.
- A working installation of **Docker Compose**

### 2. Configuration

All project configuration is managed through a `.env` file.
You can open the `.env` file to customize which base Morpheus image to use or what local ports to expose. For a first run, the default settings are fine.

### 3. Build and Run the Application

Run the following command from the project's root directory:

```bash
# This command builds the API image if it doesn't exist,
# and then starts all services (web, redis, cache) in the background.
docker compose up --build -d
```

Your application stack is now running!
*   The web service is available at **`http://localhost:1500`**.
*   The Nginx cache is available at **`http://localhost:1501`**.

The default `docker-compose.yml` provides a complete stack using both Redis and Nginx for caching.

### 4. Creating a Distributable Archive

After building the image, you can package it into a self-contained `.tar` archive for others to use. See the **[Archived Project Restoration Guide](./README.archive.md)** for instructions on how to use the archive.

---

## Usage

The API provides endpoints for analyzing words. See [BAMBOO.md](./docs/BAMBOO.md) and [RAW.md](./docs/RAW.md) for more documentation.

### Examples

#### Greek

`http://localhost:1500/analysis/word?lang=grc&engine=morpheusgrc&word=ἄνθρωπος`

```json
{
  "RDF":{
    "Annotation":{
      "about":"urn:TuftsMorphologyService:ἄνθρωπος:morpheusgrc",
      "creator":{
        "Agent":{
          "about":"org.perseus:tools:morpheus.v1"
        }
      },
      "created":{
        "$":"2020-01-01T00:00:00.000000"
      },
      "hasTarget":{
        "Description":{
          "about":"urn:word:ἄνθρωπος"
        }
      },
      "title":{

      },
      "hasBody":{
        "resource":"urn:uuid:idme9bc7066c297cbb5b76e7750cb374940290ce9480c26840a0c1acfd400016786"
      },
      "Body":{
        "about":"urn:uuid:idme9bc7066c297cbb5b76e7750cb374940290ce9480c26840a0c1acfd400016786",
        "type":{
          "resource":"cnt:ContentAsXML"
        },
        "rest":{
          "entry":{
            "uri":null,
            "dict":{
              "hdwd":{
                "lang":"grc",
                "$":"ἄνθρωπος"
              },
              "pofs":{
                "order":3,
                "$":"noun"
              },
              "decl":{
                "$":"2nd"
              },
              "gend":{
                "$":"masculine"
              }
            },
            "infl":{
              "term":{
                "lang":"grc",
                "stem":{
                  "$":"ἀνθρωπ"
                },
                "suff":{
                  "$":"ος"
                }
              },
              "pofs":{
                "order":3,
                "$":"noun"
              },
              "decl":{
                "$":"2nd"
              },
              "case":{
                "order":7,
                "$":"nominative"
              },
              "gend":{
                "$":"masculine"
              },
              "num":{
                "$":"singular"
              },
              "stemtype":{
                "$":"os_ou"
              }
            }
          }
        }
      }
    }
  }
}
```

#### Latin

`http://localhost:1500/analysis/word?lang=lat&engine=morpheuslat&word=homo`

```json
{
  "RDF":{
    "Annotation":{
      "about":"urn:TuftsMorphologyService:homo:morpheuslat",
      "creator":{
        "Agent":{
          "about":"org.perseus:tools:morpheus.v1"
        }
      },
      "created":{
        "$":"2020-01-01T00:00:00.000000"
      },
      "hasTarget":{
        "Description":{
          "about":"urn:word:homo"
        }
      },
      "title":{

      },
      "hasBody":{
        "resource":"urn:uuid:idm1f6495b96a1082a031f512e601dd2f8277cb96aa6b3da261d9a7a4df18316e72"
      },
      "Body":{
        "about":"urn:uuid:idm1f6495b96a1082a031f512e601dd2f8277cb96aa6b3da261d9a7a4df18316e72",
        "type":{
          "resource":"cnt:ContentAsXML"
        },
        "rest":{
          "entry":{
            "uri":null,
            "dict":{
              "hdwd":{
                "lang":"lat",
                "$":"homo"
              },
              "pofs":{
                "order":3,
                "$":"noun"
              },
              "decl":{
                "$":"3rd"
              },
              "gend":{
                "$":"masculine/feminine"
              }
            },
            "infl":[
              {
                "term":{
                  "lang":"lat",
                  "stem":{
                    "$":"hom"
                  },
                  "suff":{
                    "$":"o_"
                  }
                },
                "pofs":{
                  "order":3,
                  "$":"noun"
                },
                "decl":{
                  "$":"3rd"
                },
                "case":{
                  "order":7,
                  "$":"nominative"
                },
                "gend":{
                  "$":"masculine"
                },
                "num":{
                  "$":"singular"
                },
                "stemtype":{
                  "$":"o_inis"
                }
              },
              {
                "term":{
                  "lang":"lat",
                  "stem":{
                    "$":"hom"
                  },
                  "suff":{
                    "$":"o_"
                  }
                },
                "pofs":{
                  "order":3,
                  "$":"noun"
                },
                "decl":{
                  "$":"3rd"
                },
                "case":{
                  "order":7,
                  "$":"nominative"
                },
                "gend":{
                  "$":"feminine"
                },
                "num":{
                  "$":"singular"
                },
                "stemtype":{
                  "$":"o_inis"
                }
              }
            ]
          }
        }
      }
    }
  }
}
```

---

## Alternative: Running Natively (Advanced)

It is also possible to run the application natively on a Unix/Linux system, but this is not recommended as it requires manual dependency management.

**Requirements:**
- Ruby (~3.0)
- Bundler
- A compiled `morpheus` executable on your `$PATH`
- The Morpheus `stemlib` directory

**Installation & Execution:**
```bash
bundle install

# You must provide the path to your stemlib directory
MORPHLIB=/path/to/stemlib bundle exec ruby app.rb
```