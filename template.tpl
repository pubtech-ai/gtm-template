___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Pubtech CMP",
  "categories": [
    "TAG_MANAGEMENT",
    "PERSONALIZATION"
  ],
  "brand": {
    "id": "github.com_pubtech-ai",
    "displayName": "Pubtech-ai",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAABEVBMVEUAAAD4XDr5XDr4Wzr4Wzn7Wzv4XDn5Wzr4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr5XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDn4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr4Wzr4XDr4XDr4XDr4Wzn4XDr4XDr4XDr4XDr4XDr4Wzn4XDr4XDr5Wzn4Wzn4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr5Wjr3XDn4XDr4XDr4XDr4XDr4XDr4XDr4XDr4XDr5Wzr3Wzn4Wzn4XDr4XDr4XDr4XDr4XDr4XDr4XDr4Wzr4XDr4XDr4XDr4XDr4XDr4Wzr4XDr4XDr3XDr4XDr4XDr4XDr///+SzkOHAAAAWXRSTlMAAAAAAAAAAApLRQYEQk0LCof38UHt+YwMiPtZTvqN/JcOCoqYDwuWlYKdDQmUhgQDdfaqFRer9HADBnf1/qcWqfNyBQYFphMUc/1eWwV08Ok94gY6NQItMwAqe10AAAABYktHRFoDu6WiAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH5gkaETY4godnGQAAAOxJREFUOMvl0OdWwjAUwPGE3VL2UCtFUEA2VtSqLFkOlgo47vu/CD20gd70DSCfcvL/nZPkEnJUi/oE0U/NvRQIhijujnAkGhMYiCeSJ6cU97MkyOcMpKKgpK1i2y8yWQYurxQkjJ7L7w6cBSRsnRNGv86jR1mE0YtZ7lt7IZUUgHKF64S4qjUAud4gN+otQPOOurnB0PsHAO3xiXieW23odHtY6P2lA/3B0EuIZ6RqvLB2/bYxL3C3C74z8frGRv2ud+1j300xmTIwm4Cmzp3o1+PF55fIwPcyscBdP1ytfyQGfv/+57bJHfbaAEzELjLI3jWUAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDIyLTA5LTI2VDE3OjU0OjU2KzAwOjAwyNIbxAAAACV0RVh0ZGF0ZTptb2RpZnkAMjAyMi0wOS0yNlQxNzo1NDo1NiswMDowMLmPo3gAAABXelRYdFJhdyBwcm9maWxlIHR5cGUgaXB0YwAAeJzj8gwIcVYoKMpPy8xJ5VIAAyMLLmMLEyMTS5MUAxMgRIA0w2QDI7NUIMvY1MjEzMQcxAfLgEigSi4A6hcRdPJCNZUAAAAASUVORK5CYII\u003d"
  },
  "description": "Integrate the Google Consent Mode with PubConsent CMP of Pubtech.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "PARAM_TABLE",
    "name": "defaultSettings",
    "displayName": "Default settings",
    "paramTableColumns": [
      {
        "param": {
          "type": "TEXT",
          "name": "region",
          "displayName": "Region (leave blank to have consent apply to all regions)",
          "simpleValueType": true
        },
        "isUnique": true
      },
      {
        "param": {
          "type": "TEXT",
          "name": "granted",
          "displayName": "Granted Consent Types(comma separated)",
          "simpleValueType": true
        },
        "isUnique": false
      },
      {
        "param": {
          "type": "TEXT",
          "name": "denied",
          "displayName": "Denied Consent Types (comma separated)",
          "simpleValueType": true
        },
        "isUnique": false
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "ads_data_redaction",
    "checkboxText": "Ads Data Redaction",
    "simpleValueType": true
  },
  {
    "type": "CHECKBOX",
    "name": "urlPassThrough",
    "checkboxText": "urlPassThrough",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// The first two lines are optional, use if you want to enable logging
const log = require('logToConsole');
//log('data =', data);
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const getCookieValues = require('getCookieValues');
const callInWindow = require('callInWindow');
const createQueue = require('createQueue');
const gtagSet = require('gtagSet');
const setInWindow = require('setInWindow');

/**
 * Splits the input string using comma as a delimiter, returning an array of
 * strings
 */
const splitInput = (input) => {
  if (typeof input == 'string') {
    return input.split(',')
      .map(entry => entry.trim())
      .filter(entry => entry.length !== 0);
  }

  return [];
};

/**
 * Processes a row of input from the default settings table, returning an object
 * which can be passed as an argument to setDefaultConsentState
 */
const parseCommandData = (settings) => {
  const regions = splitInput(settings.region);
  const granted = splitInput(settings.granted);
  const denied = splitInput(settings.denied);
  const commandData = {};
  if (regions.length > 0) {
    commandData.region = regions;
  }
  granted.forEach(entry => {
    commandData[entry] = 'granted';
  });
  denied.forEach(entry => {
    commandData[entry] = 'denied';
  });
  return commandData;
};

/**
 * Called when consent changes. Assumes that consent object contains keys which
 * directly correspond to Google consent types.
 */
const onUserConsent = (consent) => {
  const consentModeStates = {
    ad_storage: consent.adConsentGranted ? 'granted' : 'denied',
    ad_user_data: consent.adUserDataGranted ? 'granted' : 'denied',
    ad_personalization: consent.adPersonalizationGranted ? 'granted' : 'denied',
    analytics_storage: consent.analyticsConsentGranted ? 'granted' :
                                                            'denied',
    functionality_storage: consent.functionalityConsentGranted ? 'granted' :
                                                                    'denied',
    personalization_storage:
        consent.personalizationConsentGranted ? 'granted' : 'denied',
    security_storage: consent.securityConsentGranted ? 'granted' : 'denied',
  };

  //log('updateConsentState', consentModeStates);

  updateConsentState(consentModeStates);

  //For testing purpose live and here
  setInWindow('__pubtech_cmp_gcm_updateConsentState', consentModeStates, true);
};

function readConsentsFromCMP(consentStrings, tcModel, pcModel, vendorsData) {
      //This use googleConsents integration inside our CMP.
      log('vendorsDataGoogleConsents =', vendorsData.googleConsents);
      onUserConsent(vendorsData.googleConsents);
}

/**
 * Executes the default command, sets the developer ID, and sets up the consent
 * update callback
 */
const main = (data) => {
  // Set developer ID
  gtagSet({
    'developer_id.dYWU3OD': true,
    'ads_data_redaction': data.ads_data_redaction,
    'url_passthrough': data.urlPassThrough
  });
  // Set default consent state(s)
  if (data.defaultSettings) {
    data.defaultSettings.forEach(settings => {
      const defaultData = parseCommandData(settings);
      defaultData.wait_for_update = 500;
      setDefaultConsentState(defaultData);

      //For testing purpose live and here
      setInWindow('__pubtech_cmp_gcm_defaultConsentState', defaultData, true);
    });
  } else {
     // Set default consent state values for all regions
    setDefaultConsentState({
      "ad_storage": 'denied',
      "ad_user_data": 'denied',
      "ad_personalization": 'denied',
      "analytics_storage": 'denied',
      "functionality_storage": 'denied',
      "personalization_storage": 'denied',
      "security_storage": 'denied',
      "wait_for_update": 500,
    });
  }

  data.gtmOnSuccess();

   /**
    * Add event listener to trigger update when consent changes
    *
    * Calling __pub_tech_cmp_on_consent_queue__pre implemented by PubConsent CMP.
    * The the queue__pre is only for internal usage like this integration. Every incorrect usage may cause delay.
    * The callback should be called with an object containing fields that correspond to the five built-in Google consent types.
    * The vendorsData.googleConsents is supposed to comply with this standard.
    */
  const consentReadyPush = createQueue('__pub_tech_cmp_on_consent_queue__pre');
  consentReadyPush(readConsentsFromCMP);
};

main(data);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__pub_tech_cmp_on_consent_queue__pre"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__pubtech_cmp_gcm_updateConsentState"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__pubtech_cmp_gcm_defaultConsentState"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ads_data_redaction"
              },
              {
                "type": 1,
                "string": "url_passthrough"
              },
              {
                "type": 1,
                "string": "developer_id.dYWU3OD"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "euconsent-v2"
              },
              {
                "type": 1,
                "string": "pubtech-cmp-pcstring"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "wait_for_update"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Changed consent by PubConsent CMP
  code: |+
    const isConsentGranted = require('isConsentGranted');
    const copyFromWindow = require('copyFromWindow');
    const log = require('logToConsole');
    const callLater = require('callLater');

    const mockData = {
      defaultSettings: [
        {
          granted: '',
          denied: 'ad_storage,analytics_storage,functionality_storage,personalization_storage,security_storage',
          region: '',
          ads_data_redaction: true,
        }
      ],
    };

    // Call runCode to run the template's code.
    runCode(mockData);

    const pubtechQueue = copyFromWindow('__pub_tech_cmp_on_consent_queue__pre');

    const googleConsents = {
        adConsentGranted: false,
        analyticsConsentGranted: false,
        functionalityConsentGranted: false,
        personalizationConsentGranted: false,
        securityConsentGranted: false,
    };

    pubtechQueue[0]('','','', {googleConsents: googleConsents});

    const updateConsentStateConfigured = copyFromWindow('__pubtech_cmp_gcm_updateConsentState');

    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();

    assertThat(updateConsentStateConfigured.ad_storage).isEqualTo('denied');
    assertThat(updateConsentStateConfigured.analytics_storage).isEqualTo('denied');
    assertThat(updateConsentStateConfigured.functionality_storage).isEqualTo('denied');
    assertThat(updateConsentStateConfigured.personalization_storage).isEqualTo('denied');
    assertThat(updateConsentStateConfigured.security_storage).isEqualTo('denied');
    //assertThat(isConsentGranted("security_storage")).isEqualTo(true);

- name: Default consent test
  code: |-
    const isConsentGranted = require('isConsentGranted');
    const copyFromWindow = require('copyFromWindow');

    const mockData = {
      defaultSettings: [
        {
          granted: 'ad_storage,analytics_storage,functionality_storage,personalization_storage,security_storage',
          denied: '',
          region: '',
          ads_data_redaction: true,
        }
      ],
    };

    // Call runCode to run the template's code.
    runCode(mockData);

    assertThat(isConsentGranted("ad_storage")).isEqualTo(true);
    assertThat(isConsentGranted("analytics_storage")).isEqualTo(true);
    assertThat(isConsentGranted("functionality_storage")).isEqualTo(true);
    assertThat(isConsentGranted("personalization_storage")).isEqualTo(true);
    assertThat(isConsentGranted("security_storage")).isEqualTo(true);

    const defaultConsentStateConfigured = copyFromWindow('__pubtech_cmp_gcm_defaultConsentState');

    assertThat(defaultConsentStateConfigured.ad_storage).isEqualTo('granted');
    assertThat(defaultConsentStateConfigured.analytics_storage).isEqualTo('granted');
    assertThat(defaultConsentStateConfigured.functionality_storage).isEqualTo('granted');
    assertThat(defaultConsentStateConfigured.personalization_storage).isEqualTo('granted');
    assertThat(defaultConsentStateConfigured.security_storage).isEqualTo('granted');

    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Created on 05/06/2023, 11:36:59


