# Technical work samples and verification links
**Daniel Munoz | Auckland, New Zealand | Updated 4 November 2026**

[← GitHub profile](README.md) · [Contact me](mailto:danjosephmunoz@gmail.com?subject=IT%20support%20or%20QA%20opportunity)

## What this page proves

I'm working towards entry-level **IT support, technical QA, systems/network support and implementation** work. These projects show practical problem definition, requirements, Linux/Android troubleshooting, test scenarios, GitHub workflow use and documentation. I use **AI-assisted coding** and am still developing independent software engineering skills. Automated checks below are **build/test evidence**, not proof of paid client work, production reliability, or formal certification.

| Project / evidence | What I worked on | Independently checkable evidence | Limits |
| --- | --- | --- | --- |
| **[Net Intel](https://github.com/damunozx123-debug/net-intel-app-v9)** | Local-first diagnostic prototype, explicit consent, simulated customer demo, regression tests and staged income experiment. | [Passing validation on main](https://github.com/damunozx123-debug/net-intel-app-v9/actions/runs/41731872787), [static-route regression fix](https://github.com/damunozx123-debug/net-intel-app-v9/commit/66b2a7c2c724d61bf1ad6fb48e975c857daf952c), [honest demo and run instructions](https://github.com/damunozx123-debug/net-intel-app-v9#5-minute-interactive-customer-demo), [work board](https://github.com/damunozx123-debug/net-intel-app-v9/issues). | Demo measurements are simulated; no verified customer sales, live field accuracy or deployed production service. |
| **[PatternX](https://github.com/damunozx123-debug/Patternx)** | Native Android prototype, local-first data design, documented import validation and screenshot CI troubleshooting. | [Specific emulator disk-space fix](https://github.com/damunozx123-debug/Patternx/commit/a7413db0b759650cdc8a3e605a6c6dac9b3b48c8), [passing screenshot workflow](https://github.com/damunozx123-debug/Patternx/actions/runs/41729948322), [passing APK build](https://github.com/damunozx123-debug/Patternx/actions/runs/41729948434), [captured preview screenshot commit](https://github.com/damunozx123-debug/Patternx/commit/1dbdc9bc6b0b06512c45ac414d6b51c342a8b6a2). | Debug-build prototype, not a production-signed release; some modules are planned. |
| **[Vehicle Forge X](https://github.com/damunozx123-debug/vehicle-forge-x)** | Android automotive diagnostic workflows, guarded read-only protocols, simulator and documentation for safe tests. | [Beta APK release](https://github.com/damunozx123-debug/vehicle-forge-x/releases/tag/v0.3.0-beta.3), [passing beta publish run](https://github.com/damunozx123-debug/vehicle-forge-x/actions/runs/41589522407), [limitations and supported features](https://github.com/damunozx123-debug/vehicle-forge-x#what-is-implemented). | No independently verified manufacturer-specific coding or vehicle-wide compatibility; beta APK is debug-signed. |
| **[AI Cost Sensitivity Calculator](https://github.com/damunozx123-debug/ai-certainty-calculator)** | Prototype for communicating assumed infrastructure costs and what-if scenarios. | [Passing test/screenshot workflow](https://github.com/damunozx123-debug/ai-certainty-calculator/actions/runs/41580691398), [scenario screenshot commit](https://github.com/damunozx123-debug/ai-certainty-calculator/commit/4e3386069a48a9ce9d751128ed7fe32c96a7cb84). | Hypothetical scenarios; not actual cloud savings or an audited calculator. |
| **[GPU Efficiency Lab](https://github.com/damunozx123-debug/gpu-efficiency-lab-android)** | Android scenario/calculation prototype and automated build troubleshooting. | [Passing Android APK workflow](https://github.com/damunozx123-debug/gpu-efficiency-lab-android/actions/runs/41728525075), [CI SDK-manager fix](https://github.com/damunozx123-debug/gpu-efficiency-lab-android/commit/df5e7ec8db98b3093c49a03934718bcf4c856ba7). | Estimates are assumption-based; not measured hardware benchmarks or a production app. |
| **[DAN-OS](https://github.com/damunozx123-debug/dan-os)** | Local-first orchestration concepts and limited read-only app-bridge prototype. | [Passing bridge validation](https://github.com/damunozx123-debug/dan-os/actions/runs/41732402442), [implementation commit](https://github.com/damunozx123-debug/dan-os/commit/1adaffe76beb342084cd93b6a020f932f39ecdbf). | Prototype only; no claim of secure multi-user production deployment. |

## Example of a reproducible debugging task

**PatternX: emulator screenshots would not capture.** Android APK compilation passed but emulator startup failed in GitHub Actions. I examined the job log; it reported **7,108.99 MB free versus 7,372.80 MB needed** for the emulator userdata partition.

- **Diagnosis:** insufficient runner disk space, rather than an Android source compilation failure.
- **Change:** amended the screenshot workflow to remove unused SDK NDK/CMake components after the APK build and before emulator startup.
- **Verification:** [commit](https://github.com/damunozx123-debug/Patternx/commit/a7413db0b759650cdc8a3e605a6c6dac9b3b48c8) followed by a [successful screenshot run](https://github.com/damunozx123-debug/Patternx/actions/runs/41729948322) and [captured screenshot](https://github.com/damunozx123-debug/Patternx/commit/1dbdc9bc6b0b06512c45ac414d6b51c342a8b6a2).

This is evidence of identifying a build-environment failure and verifying a targeted correction. It does not imply the entire application is production-ready.

## Clear route from these samples to income

1. **Primary: employment.** Apply for junior IT support, service desk, product support, technical QA, or supervised infrastructure work. Present the specific bug report, test logs and README documentation as work samples. The qualification path is being explored, not completed.
2. **Secondary: small scoped troubleshooting or QA tasks.** Offer documented, owner-authorised Linux/Android/Termux troubleshooting, bug reproduction, setup or report writing; agree on scope and rate before accepting work.
3. **Experimental: network diagnostic pilot.** [Net Intel](https://github.com/damunozx123-debug/net-intel-app-v9) proposes an NZ$149 remote network-health check, subject to feasibility, consent and actual demand. [Offer detail](https://github.com/damunozx123-debug/ventoy-fetch/blob/master/WORK_WITH_ME.md) and [discovery milestones](https://github.com/damunozx123-debug/net-intel-app-v9/issues/3). **Proposed price is not earned income.**

## How to interpret the evidence

- **Green GitHub Actions status** means the configured checks passed for that particular commit, not that an employer has independently tested the application.
- **Debug APKs, screenshots and simulated data** are identified as such.
- **Public commits and reports** record testable progress, not an academic qualification or paid commercial traction.
- Client details, personal finances, passwords and private network data are excluded from this public portfolio.

**Available for:** entry-level technical work, structured training and bounded technical collaboration in Auckland / remote.  
**Contact:** [danjosephmunoz@gmail.com](mailto:danjosephmunoz@gmail.com?subject=Technical%20work%20sample).
