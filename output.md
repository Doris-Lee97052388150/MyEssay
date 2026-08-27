# Hybrid Cryptographic Cross-Domain Authentication and Illegal UAV Interception Scheme for Low-Altitude Airspace

## Abstract

To address security pain points in long-distance cross-domain flight scenarios under the low-altitude economy—such as single points of failure in centralized CAs, high latency during mass UAV concurrent authentication, cross-domain trajectory privacy leakage, and illegal "black-flight" UAVs laundering identities to repeatedly intrude—this paper proposes a hybrid architecture cross-domain authentication scheme. The scheme integrates lattice-based post-quantum cryptography, BLS short signatures, Sparse Merkle Trees (SMT), IPFS distributed storage, consortium blockchain, and Zero-Knowledge Proofs (ZKP). First, an elastic inner and outer boundary mechanism for airspace is defined to enable early detection of outbound UAV behavior. Second, a two-stage inter-domain interaction flow consisting of two-layer pre-authentication and formal authentication is designed, relying on proxy re-encryption to complete lossless inter-domain ciphertext permission conversion. Blind signatures generate global anonymous pseudonyms to protect routine trajectory privacy. Combined with chip PUF hardware fingerprints, a network-wide hardware deadlist is constructed, paired with SMT non-membership proofs to achieve malicious UAV registration-stage interception, thoroughly resolving identity-whitening vulnerabilities of illegal UAVs. The underlying layer adopts a hierarchical cryptographic system: the backbone trust chain utilizes NIST-standard Dilithium lattice cryptography to resist quantum attacks, air-to-ground interface communication uses BLS aggregate short signatures to reduce transmission overhead, and a modified dynamic accumulator is deployed for pseudonym obfuscation, avoiding traditional accumulator synchronization bottlenecks. Simulation results based on NS-3 indicate millisecond-level cross-domain verification and support for concurrent access of batch UAVs, satisfying comprehensive security properties such as mutual authentication, unforgeability, strong unlinkability, location privacy, immediate revocation, and physical tamper resistance, making it highly suitable for long-endurance industry-grade UAV cross-domain management scenarios like power line inspection, logistics delivery, and security patrol.

**Keywords**: UAV cross-domain authentication; low-altitude airspace; blockchain; lattice cryptography; zero-knowledge proof; illegal flight interception; privacy protection; sparse Merkle tree.

---

## 1. Introduction

### 1.1 Research Background

With the large-scale development of the low-altitude economy, the population of consumer and industrial Unmanned Aerial Vehicles (UAVs) continues to expand. Demand for long-distance missions such as cross-regional inspection, logistics transport, and wide-area security has surged. Consequently, a large number of illegal "black-flight" activities—unauthorized flights detached from local airspace management—have emerged, severely disrupting airspace order. Existing airspace management is partitioned into independent domains according to administrative and functional boundaries. Legitimate UAVs crossing domains must apply for temporary flight permits from third parties in advance. However, traditional authentication architectures suffer from multiple flaws: centralized Certificate Authorities (CAs) represent single points of failure; heterogeneous multi-domain trust systems struggle with interoperability; computation and communication overheads explode under high-concurrency access; and malicious UAVs can modify software identifiers or reset communication IDs to disguise themselves as legitimate devices, evading cross-domain control and re-registering ("identity laundering") after being blacklisted. Furthermore, UAV flight trajectories can be reconstructed by stitching logs across multiple domains, posing significant location privacy risks.

Most existing UAV cross-domain authentication schemes rely on a single cryptographic scheme or a pure distributed architecture, making it difficult to simultaneously satisfy quantum resistance, lightweight onboard computation, real-time device revocation, strong privacy protection, and illegal flight interception. Targeting multi-department collaborative airspace control scenarios (civil aviation, air traffic control, local public security), this paper designs an elastic boundary triggering mechanism, a two-stage cross-domain authentication process, a hardware-fingerprint-level anti-laundering system, and a blockchain-IPFS collaborative storage architecture. By hierarchically deploying hybrid cryptographic primitives, the scheme balances security and efficiency, achieving seamless cross-domain access for legitimate UAVs while accurately capturing and permanently blocking disguised illegal UAVs.

### 1.2 Core Research Problems

1. Airspace domain boundary determination mechanisms are rigid and fail to adapt to dynamic UAV flight speeds and communication latencies, leading to delayed triggers and control failure after boundary crossing;
2. Traditional centralized PKI cross-domain trust chains are lengthy with high single-point-of-failure risks, causing excessive authentication latency during massive concurrent access and failing real-time control demands;
3. Under anonymous authentication, malicious blacklisted UAVs can change software identifiers to re-register, leaving an identity-laundering vulnerability without a hardware-level permanent interception mechanism;
4. Single cryptographic paradigms fail to balance onboard low-computational power requirements with future quantum attack risks, while cross-domain trajectory exchanges risk privacy leakage;
5. Device revocation status synchronization suffers from time lags; traditional Certificate Revocation Lists (CRLs) entail massive storage and query overheads, failing to achieve millisecond-level verification.

### 1.3 Paper Structure

The remainder of this paper is organized as follows: Section 2 reviews literature on cross-domain authentication in UAVs, VANETs, and IIoT, analyzing innovations and limitations; Section 3 introduces preliminary knowledge on cryptography, distributed storage, and blockchain; Section 4 details the overall architecture and execution workflow across six core modules: system registration, elastic boundary processing, inter-domain pre-authentication, formal cross-domain authentication, trust update & revocation, and anti-laundering interception; Section 5 provides parameter definitions, cryptographic instantiations, boundary algorithms, hardware specs, mathematical derivations, and accumulator optimizations; Section 6 outlines the simulation setup; Section 7 concludes the paper and discusses future work.

---

## 2. Related Work

This section reviews cross-domain authentication literature across UAV networks, Vehicular Ad-Hoc Networks (VANETs), and Industrial IoT (IIoT), summarizing key contributions, limitations, and inspirations (Table 1).

**Table 1 Summary of Core Content, Innovations, and Inspirations from Related Literature**

| Ref. | Core Content | Innovations | Inspirations / Limitations |
| :---: | :--- | :--- | :--- |
| [1] | Trust-based batch authentication for UAVs | Trust metric evaluation, batch verification | Lacks post-quantum security; centralized trust bottleneck. |
| [2] | Blockchain cross-domain trajectory privacy for UAVs | Smart contract validation, trajectory obfuscation | High consensus latency; lacks hardware anti-laundering. |
| [3] | Revocable cross-domain authentication in VANETs | Dynamic accumulator revocation, identity privacy | Frequent accumulator sync overhead during high concurrency. |
| [4] | Edge-assisted identity anonymous authentication | Lightweight bilinear pairing, edge caching | Single CA failure risk; no elastic boundary prediction. |
| [5] | Smart factory decentralized authentication | Permissioned blockchain, zero-knowledge proofs | Designed for static IIoT; high mobility UAV latencies. |
| [6] | Smart contract roaming for vehicular networks | Distributed consensus, automatic key agreement | High chain storage; no hardware fingerprint binding. |

### 2.1 Limitations of Existing Schemes

1. **Single Trust Architecture:** Most schemes rely purely on centralized PKI or pure blockchain; the former suffers from single points of failure, while the latter incurs consensus latency, failing to balance real-time responsiveness with robustness;
2. **Monolithic Cryptography:** Relying solely on ECC, bilinear pairings, or chaotic maps fails to simultaneously provide post-quantum security and onboard lightweight performance;
3. **Absence of Anti-Laundering:** Software-based pseudonym revocation allows malicious devices to re-register by flashing firmware or modifying IDs;
4. **Rigid Boundaries:** Lack of adaptive geofencing triggers cross-domain workflows only after physical crossing, causing control lag;
5. **Revocation Time-Lag:** Reliance on CRL/OCSP leaves window periods for malicious access without local millisecond-level offline verification.

### 2.2 Main Innovations of Proposed Scheme

1. **Adaptive Elastic Airspace Boundary Model:** Dynamically computes safety margins based on speed, heading, positioning error, and latency to trigger early pre-authentication;
2. **Two-Stage Hierarchical Workflow:** Completes pre-authentication in boundary buffer zones and executes formal dual authentication upon physical crossing using proxy re-encryption;
3. **Hardware Fingerprint Anti-Laundering:** Combines SRAM-PUF deadlists with SMT non-membership proofs to block re-registration at the physical hardware layer;
4. **Layered Hybrid Cryptography:** Uses Dilithium lattice cryptography on the backbone chain and BLS aggregate short signatures over the air interface, paired with modified accumulators;
5. **On-Chain/Off-Chain Collaborative Storage:** Stores only SMT root hashes and IPFS CIDs on-chain, offloading heavy data to IPFS;
6. **Complete Closed-Loop Security:** Integrates blind signatures and ZKP for strong privacy, smart contracts for global irreversible revocation, and full defense against MiTM, replay, and physical tampering.

---

## 3. Preliminaries

This section introduces 11 foundational cryptographic primitives and storage paradigms: bilinear pairings, dynamic accumulators, extended Chebyshev chaotic maps, lattice cryptography, proxy re-encryption, security evaluation metrics, digital signatures, SMT, IPFS, consortium blockchain, and ZKP.

### 3.1 Bilinear Pairings

Let $e: G_1 	imes G_2 \longrightarrow G_T$ be a bilinear map where $G_1, G_2$ are additive cyclic groups and $G_T$ is a multiplicative group with generators $P, Q$. Key properties:
1. Bilinearity: $orall a,b\in \mathbb{Z}, e(aP,bQ)=e(P,Q)^{ab}$;
2. Non-degeneracy: $e(P,Q)
eq 1_{G_T}$;
3. Computability: Efficient polynomial-time algorithms exist.

Constructed via Weil/Tate pairings on BLS12-381 curves for short signatures. Benefits include ultra-short signatures and batch verification, though paired with short-term session keys to mitigate quantum vulnerability.

### 3.2 Dynamic Accumulators

Dynamic RSA accumulators offer $\mathcal{O}(1)$ evaluation for membership proof. To prevent synchronization bottlenecks, this scheme decouples accumulator updates from device revocation, embedding dynamic accumulator values ($ACC$) directly into signatures for domain obfuscation.

### 3.3 Proxy Re-Encryption (PRE)

PRE enables ciphertext transformation across permission domains without revealing plaintext or private keys. A proxy node converts ciphertexts encrypted under Domain A's public key into ciphertexts decryptable by Domain B using a re-encryption key $rk_{A 	o B}$.

---

## 4. Proposed Framework Architecture

The framework consists of six core modules: System Registration, Elastic Geofence Boundary Processing, Inter-Domain Pre-Authentication, Formal Cross-Domain Authentication, Trust Update & Revocation, and Anti-Laundering Interception.

### 4.1 System Registration

#### 4.1.1 Domain and Consortium Blockchain Initialization

1. $N$ domain managers $\mathcal{D}_1, \dots, \mathcal{D}_N$ join the consortium blockchain as consensus nodes;
2. Each domain generates a Dilithium lattice keypair:
   $$(pk_{\mathcal{D}_i}, sk_{\mathcal{D}_i}) \leftarrow 	ext{Lattice.KeyGen}(1^\lambda)$$
   Public key $pk_{\mathcal{D}_i}$ is published on-chain;
3. Independent dynamic accumulators with domain-specific nonces are initialized alongside 256-depth SMTs for storing pseudonyms ($PID$) and authorization states.

#### 4.1.2 Hardware-Bound Anonymous Registration

1. **PUF Extraction:** The UAV extracts a 256-bit unique SRAM-PUF fingerprint $Fingerprint_j$;
2. **Credential Blind Construction:** The UAV generates secret $s_j$, constructs $M = Real\_ID_j \parallel Fingerprint_j \parallel s_j$, and blinds it to $M' = 	ext{Blind}(M, r)$;
3. **Home Domain Blind Signature:** Home domain $\mathcal{D}_A$ signs $M'$ using $sk_{\mathcal{D}_A}$, yielding $\sigma'$;
4. **Unblind and Pseudonym Derivation:** The UAV unblinds $\sigma'$ to get $\sigma_j$ and computes $PID_j = 	ext{Hash}(M \parallel \sigma_j)$;
5. **Off-Chain SMT & On-Chain Anchoring:** $PID_j$ is inserted into domain $\mathcal{D}_A$'s SMT, and the updated SMT root $Root_{\mathcal{D}_A}$ and IPFS CID are anchored on-chain.

### 4.2 Geofence Boundaries and Elastic Inner-Boundaries

An elastic boundary model is established to dynamically calculate the dynamic safety margin $d$:

$$d = v(t) \cdot \cos(\theta) \cdot \left[ \Delta T_{network}(RSSI) + \Delta T_{PRE} + \Delta T_{P2P}\right] + 3\sigma_{GNSS}$$

```
+-------------------------------------------------------------+
|                     Domain A                                |
|                                                             |
|    +---------------------------------------------------+    |
|    |               Core Zone (Normal Flight)           |    |
|    |                                                   |    |
|    +---------------------------------------------------+    |
|          Boundary Offset d (Safety Margin)                  |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  |
| Elastic Inner Boundary [Outbound Limit]: Starts Outbound    |
|                                         Timer               |
+-------------------------------------------------------------+
================ Physical Airspace Boundary ==================
+-------------------------------------------------------------+
| Elastic Outer Boundary [Inbound Limit]: Target Pre-Auth     |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  |
|                     Domain B                                |
+-------------------------------------------------------------+
```

When distance $L(t) \le d$, outbound timer $T_{out}$ starts. If $T_{out} > T_{max} = 15	ext{s}$, pre-authentication is triggered.

### 4.3 Inter-Domain Pre-Authentication

While in the buffer zone, the UAV transmits a lightweight pre-authentication request using a 48-byte BLS short signature:

$$Req_{pre} = \{PID_j, \mathcal{D}_B, Timestamp, \mathcal{S}_{ign\_sl}(PID_j \parallel \mathcal{D}_B)\}$$

Domain $\mathcal{D}_A$ converts the authorization ciphertext to Domain $\mathcal{D}_B$ using $rk_{A 	o B}$ and pushes $CT_{\mathcal{D}_B}$ to $\mathcal{D}_B$ via P2P edge links.

### 4.4 Formal Cross-Domain Authentication

Upon crossing into Domain $\mathcal{D}_B$, the UAV responds to challenge $R_B$ with:

$$Res_{formal} = \{PID_j, 	ext{Lattice.Sign}(sk_{uav}, R_B \parallel TS_1), Proof_{smt}\}$$

Domain $\mathcal{D}_B$ verifies the lattice signature and checks $Proof_{smt}$ against on-chain root $Root_{\mathcal{D}_A}$, establishing session key $K_{session}$.

### 4.5 Trust Update and Malicious Device Revocation

When a UAV behaves maliciously, Domain $\mathcal{D}_B$ submits a revocation transaction. Smart contracts blacklist $PID_j$ globally. $\mathcal{D}_A$ removes $PID_j$ from its SMT, uploads $Root_{\mathcal{D}_A}^{new}$ to IPFS, and updates the on-chain root.

### 4.6 Illegal Flight Anti-Laundering Interception Mechanism

```
Malicious UAV with unalterable Fingerprint_j attempts re-registration
        ↓
Submit blinded registration request (with PUF fingerprint)
        ↓
Home CA pulls network-wide deadlist CID_DeadList from IPFS
        ↓
Full field fingerprint collision comparison
┌─────────────┬─────────────┐
│ Deadlist    │ Not in      │
│ Match       │ Deadlist    │
↓             ↓
Reject Blind  Verify SMT non-membership proof;
Signature;    Issue signature to derive new PID upon success
Trigger Alarm
```

---

## 5. System Parameters and Mathematical Details

### 5.1 Global Parameters

**Table 2 Global Cryptographic and System Parameters**

| Symbol | Data Type | Physical & Cryptographic Meaning / Recommended Value |
| :---: | :---: | :--- |
| $\lambda$ | Integer | Security parameter ($\lambda = 128$, NIST Level III). |
| $q$ | Prime | Lattice ring modulus $q = 8380417$. |
| $n$ | Integer | Ring dimension $n = 256$, $R_q = \mathbb{Z}_q[x]/(x^{256}+1)$. |
| $e,G_1,G_2,G_T$ | Map | BLS12-381 pairing curve ($G_1$ 48-byte signatures). |
| $pk_{\mathcal{D}_i},sk_{\mathcal{D}_i}$ | Matrix/Vector | Dilithium keypair ($k=6,l=5,\eta=4$). |
| $Fingerprint_j$ | Bitstring | 256-bit SRAM-PUF hardware fingerprint. |
| $s_j$ | Element | 128-bit secret random seed. |
| $PID_j$ | Bitstring | 256-bit global anonymous pseudonym. |
| $Root_{\mathcal{D}_A}$ | Hash | 32-byte SMT global root. |
| $T_{max}$ | Float | Elastic threshold $T_{max} = 15.0	ext{ s}$. |

### 5.2 Cryptographic Primitive Instantiations

- **Dilithium3:** Crystals-Dilithium3 with 1952-byte public key;
- **BLS Aggregate Signatures:** 48-byte short signatures aggregated via $\sigma_{agg} = \sum_{i=1}^N \sigma_i \in G_1$;
- **SMT + ZKP:** 256-depth SMT paired with zk-STARK non-interactive proofs (256 bytes);
- **IPFS Storage:** SHA2-256 / CIDv1 base58 identifiers.

### 5.3 Target UAV Hardware Specifications

**Table 3 Target UAV Technical Specs**

| Category | Specification | Quantitative Indicator |
| :---: | :---: | :---: |
| Radius | Cross-city / Inspection / Logistics | 15 km ~ 250 km |
| Speed | Medium-High Speed | 15 m/s ~ 45 m/s (Max 162 km/h) |
| Processor | Embedded Edge Chip | ARM Cortex-M7 ≥400MHz / Cortex-A53 |
| Memory | RAM / Flash | SRAM ≥512KB, DRAM ≥128MB |
| Hardware Anchor | PUF Module | 256-bit SRAM-PUF fingerprint |
| Tamper Resistance | Hardware Self-Destruct | Wipes key/fingerprint cache within 5ms of tamper |

### 5.4 Mathematical Derivations

#### 5.4.1 Dilithium Key Generation
Private key components $\mathbf{s}_1 \in R_q^5, \mathbf{s}_2 \in R_q^6$ with bounds $[-\eta, \eta]$. Matrix $\mathbf{A} \in R_q^{6 	\times 5}$. Public key vector:
$$\mathbf{t} = \mathbf{A}\mathbf{s}_1 + \mathbf{s}_2 \pmod q$$

---

## 6. Simulation Environment

Evaluated using NS-3 on Ubuntu 26.06 LTS inside VMware Workstation Pro to measure authentication latency, bandwidth overhead, and concurrent access capacity.

---

## 7. Conclusion and Future Work

### 7.1 Conclusion

This paper presented a hybrid cryptographic cross-domain authentication and illegal UAV interception scheme for low-altitude airspace. Combining lattice cryptography, BLS signatures, SMT, IPFS, consortium blockchain, and zero-knowledge proofs, the system achieves pre-authentication over elastic boundaries, lightweight cross-domain handshakes, strong trajectory privacy, and hardware-level anti-laundering protection.

### 7.2 Future Work

1. Complete quantitative NS-3 simulation benchmarks comparing latency, bandwidth, and compute consumption;
2. Develop embedded ARM hardware prototypes for PUF, lattice, and BLS firmware execution;
3. Optimize zero-knowledge proof generation speed on edge hardware;
4. Extend to multi-UAV swarm cross-domain scenarios;
5. Build compatibility layers for existing civil aviation PKI systems.

---

## References

[1] L. Rui, X. Zhang, J. Yang, and L. Liu, "Trust-Based Cross-Domain Batch Authentication Protocol for UAV Networks," in *2025 11th International Conference on Computer and Communications (ICCC)*, 2025, pp. 1715-1720.

[2] G. Qiao, P. Yang, T. Ye, and F. Han, "A Blockchain-Based Cross-Domain Authentication and Flight Trajectory Privacy Protection Scheme for Unmanned Aerial Vehicle Networks," *IEEE Internet of Things Journal*, vol. 13, no. 2, pp. 2155-2170, Jan. 2026.

[3] R. Li et al., "Blockchain-Assisted Revocable Cross-Domain Authentication for Vehicular Ad-Hoc Networks," *IEEE Transactions on Dependable and Secure Computing*, vol. 22, no. 5, pp. 4593-4607, Sept./Oct. 2025.

[4] N. Kang et al., "Identity-Based Edge Computing Anonymous Authentication Protocol," *Computers, Materials & Continua*, vol. 74, no. 1, pp. 2005-2018, 2023.

[5] Z. Cao et al., "A decentralized authentication scheme for smart factory based on blockchain," *Scientific Reports*, vol. 14, no. 1, p. 24640, Oct. 2024.

[6] K. Xue et al., "A Distributed Authentication Scheme Based on Smart Contract for Roaming Service in Mobile Vehicular Networks," *IEEE Transactions on Vehicular Technology*, vol. 71, no. 5, pp. 5284-5297, May 2022.

[7] P. Gu, "An Efficient Blockchain-based Cross-domain Authentication and Secure Certificate Revocation Scheme," in *2020 IEEE 6th ICCC*, 2020, pp. 1651-1655.

[8] Y. Sun et al., "An Efficient Pseudonymous Authentication Scheme With Strong Privacy Preservation for Vehicular Communications," *IEEE TVT*, vol. 59, no. 7, pp. 3589-3603, Sept. 2010.

[9] C. Lin et al., "BCPPA: A Blockchain-Based Conditional Privacy-Preserving Authentication Protocol for Vehicular Ad Hoc Networks," *IEEE TITS*, vol. 22, no. 12, pp. 7408-7420, Dec. 2021.

[10] M. Shen et al., "Blockchain-Assisted Secure Device Authentication for Cross-Domain Industrial IoT," *IEEE JSAC*, vol. 38, no. 5, pp. 942-954, May 2020.

[11] Z. Li et al., "Blockchain-Based Certificateless Cross-Domain Authentication Scheme in the Industrial Internet of Things," *CMC*, vol. 80, no. 3, pp. 3835-3856, Sept. 2024.

[12] J. Dong et al., "Blockchain-Based Certificate-Free Cross-Domain Authentication Mechanism for Industrial Internet," *IEEE JIOT*, vol. 11, no. 2, pp. 3316-3329, Jan. 2024.

[13] F. Wang et al., "Blockchain-Based Lightweight Message Authentication for Edge-Assisted Cross-Domain Industrial Internet of Things," *IEEE TDSC*, vol. 21, no. 4, pp. 1587-1601, July/Aug. 2024.

[15] H. Zhong et al., "Conditional privacy-preserving message authentication scheme for cross-domain Industrial Internet of Things," *Ad Hoc Networks*, vol. 144, p. 103137, May 2023.

[16] J. Cui et al., "Efficient and Anonymous Cross-Domain Authentication for IIoT Based on Blockchain," *IEEE TNSE*, vol. 10, no. 3, pp. 899-910, March/April 2023.

[17] M. Zeng et al., "Efficient Revocable Cross-Domain Anonymous Authentication Scheme for IIoT," *IEEE TIFS*, vol. 20, pp. 996-1010, 2025.

[18] Y. Chen et al., "A Trust Enhancement Scheme for Cross Domain Authentication of PKI system," in *2019 CyberC*, 2019, pp. 364-371.

[19] Y. Wu et al., "A Blockchain-Based Trust Framework for Resilient Cross-Domain UAV Service Orchestration," arXiv preprint arXiv:2603.00456, 2026.

[20] S. Liang et al., "A Lightweight Authentication and Key Agreement Scheme for Cross-Domain UAV Networks Based on Extended Chebyshev Chaotic Map and Hash Chain," in *2025 CBASE*, 2025, pp. 1-6.

[21] L. Feng et al., "TEBP-UAVs: A trusted and efficient blockchain-based protocol for cross-domain authentication in UAVs," *Computer Networks*, vol. 282, p. 112243, 2026.
