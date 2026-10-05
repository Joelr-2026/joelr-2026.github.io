/* ============================================================
   01. GLOBAL SETTINGS
============================================================ */

const prefersReducedMotion =
    window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;



/* ============================================================
   02. REVEAL ON SCROLL
============================================================ */

const revealElements =
    document.querySelectorAll(
        ".reveal"
    );


if (prefersReducedMotion) {

    revealElements.forEach(
        (element) => {
            element.classList.add(
                "visible"
            );
        }
    );

} else {

    const revealObserver =
        new IntersectionObserver(
            (entries, observer) => {

                entries.forEach(
                    (entry) => {

                        if (!entry.isIntersecting) {
                            return;
                        }

                        entry.target
                            .classList
                            .add("visible");

                        observer.unobserve(
                            entry.target
                        );

                    }
                );

            },
            {
                threshold: 0.12
            }
        );


    revealElements.forEach(
        (element) => {
            revealObserver.observe(
                element
            );
        }
    );

}



/* ============================================================
   03. HERO COUNTERS
============================================================ */

const counters =
    document.querySelectorAll(
        ".counter"
    );


function animateCounter(counter) {

    const target =
        Number(
            counter.dataset.target
        );

    const duration =
        900;

    const startTime =
        performance.now();


    function updateCounter(
        currentTime
    ) {

        const elapsed =
            currentTime -
            startTime;

        const progress =
            Math.min(
                elapsed /
                duration,
                1
            );

        const value =
            Math.round(
                target *
                progress
            );


        counter.textContent =
            value;


        if (progress < 1) {

            requestAnimationFrame(
                updateCounter
            );

        }

    }


    requestAnimationFrame(
        updateCounter
    );

}


if (prefersReducedMotion) {

    counters.forEach(
        (counter) => {

            counter.textContent =
                counter.dataset.target;

        }
    );

} else {

    const counterObserver =
        new IntersectionObserver(
            (entries, observer) => {

                entries.forEach(
                    (entry) => {

                        if (
                            !entry
                                .isIntersecting
                        ) {
                            return;
                        }


                        animateCounter(
                            entry.target
                        );


                        observer.unobserve(
                            entry.target
                        );

                    }
                );

            },
            {
                threshold: 0.6
            }
        );


    counters.forEach(
        (counter) => {

            counterObserver.observe(
                counter
            );

        }
    );

}



/* ============================================================
   04. MOBILE NAVIGATION
============================================================ */

const mobileMenuButton =
    document.getElementById(
        "mobileMenuButton"
    );


const primaryNav =
    document.getElementById(
        "primaryNav"
    );


function closeMobileMenu() {

    if (
        !primaryNav ||
        !mobileMenuButton
    ) {
        return;
    }


    primaryNav
        .classList
        .remove("open");


    mobileMenuButton
        .setAttribute(
            "aria-expanded",
            "false"
        );

}


if (
    mobileMenuButton &&
    primaryNav
) {

    /* --------------------------------------------------------
       MENU BUTTON TOGGLE
    --------------------------------------------------------- */

    mobileMenuButton
        .addEventListener(
            "click",
            () => {

                const isOpen =
                    primaryNav
                        .classList
                        .toggle(
                            "open"
                        );


                mobileMenuButton
                    .setAttribute(
                        "aria-expanded",
                        String(isOpen)
                    );

            }
        );


    /* --------------------------------------------------------
       NAV LINK CLICK = CLOSE MENU
    --------------------------------------------------------- */

    primaryNav
        .querySelectorAll(
            "a"
        )
        .forEach(
            (link) => {

                link.addEventListener(
                    "click",
                    () => {

                        closeMobileMenu();

                    }
                );

            }
        );


    /* --------------------------------------------------------
       OUTSIDE TAP / CLICK = CLOSE MENU
    --------------------------------------------------------- */

    document.addEventListener(
        "click",
        (event) => {

            const isMenuOpen =
                primaryNav
                    .classList
                    .contains(
                        "open"
                    );


            if (!isMenuOpen) {
                return;
            }


            const clickedInsideMenu =
                primaryNav.contains(
                    event.target
                );


            const clickedMenuButton =
                mobileMenuButton.contains(
                    event.target
                );


            if (
                !clickedInsideMenu &&
                !clickedMenuButton
            ) {

                closeMobileMenu();

            }

        }
    );


    /* --------------------------------------------------------
       ESCAPE KEY = CLOSE MENU
    --------------------------------------------------------- */

    document.addEventListener(
        "keydown",
        (event) => {

            if (
                event.key ===
                "Escape"
            ) {

                closeMobileMenu();

            }

        }
    );

}



/* ============================================================
   05. MOBILE MENU AUTO-CLOSE ON SCROLL
============================================================ */

let menuScrollStart =
    window.scrollY;


let menuWasOpen =
    false;


window.addEventListener(
    "scroll",
    () => {

        if (
            !primaryNav ||
            !mobileMenuButton
        ) {
            return;
        }


        const isMenuOpen =
            primaryNav
                .classList
                .contains(
                    "open"
                );


        const currentScrollY =
            window.scrollY;


        if (
            isMenuOpen &&
            !menuWasOpen
        ) {

            menuScrollStart =
                currentScrollY;

            menuWasOpen =
                true;

        }


        if (!isMenuOpen) {

            menuWasOpen =
                false;

            return;

        }


        const distanceScrolled =
            Math.abs(
                currentScrollY -
                menuScrollStart
            );


        /*
           Small accidental finger movement ko ignore karte hain.
           Proper scroll hone par menu close hoga.
        */

        if (
            distanceScrolled >
            12
        ) {

            closeMobileMenu();

            menuWasOpen =
                false;

        }

    },
    {
        passive: true
    }
);



/* ============================================================
   06. SMOOTH INTERNAL LINKS
============================================================ */

document
    .querySelectorAll(
        'a[href^="#"]'
    )
    .forEach(
        (link) => {

            link.addEventListener(
                "click",
                (event) => {

                    const href =
                        link.getAttribute(
                            "href"
                        );


                    if (
                        !href ||
                        href === "#"
                    ) {
                        return;
                    }


                    const target =
                        document
                            .querySelector(
                                href
                            );


                    if (!target) {
                        return;
                    }


                    event
                        .preventDefault();


                    target
                        .scrollIntoView({
                            behavior:
                                prefersReducedMotion
                                    ? "auto"
                                    : "smooth",

                            block:
                                "start"
                        });

                }
            );

        }
    );



/* ============================================================
   07. ACTIVE NAVBAR SECTION
============================================================ */

const navLinks =
    Array.from(
        document
            .querySelectorAll(
                ".nav-link"
            )
    );


const trackedSections =
    Array.from(
        document
            .querySelectorAll(
                "main section[id]"
            )
    );


const sectionObserver =
    new IntersectionObserver(
        (entries) => {

            entries.forEach(
                (entry) => {

                    if (
                        !entry
                            .isIntersecting
                    ) {
                        return;
                    }


                    const sectionId =
                        entry.target.id;


                    navLinks.forEach(
                        (link) => {

                            const isCurrent =
                                link
                                    .getAttribute(
                                        "href"
                                    ) ===
                                `#${sectionId}`;


                            link
                                .classList
                                .toggle(
                                    "active",
                                    isCurrent
                                );

                        }
                    );

                }
            );

        },
        {
            rootMargin:
                "-40% 0px -52% 0px",

            threshold: 0
        }
    );


trackedSections.forEach(
    (section) => {

        sectionObserver
            .observe(section);

    }
);



/* ============================================================
   08. PROFILE 3D / MOBILE AUTO ANIMATION
============================================================ */

const profileStage =
    document.getElementById(
        "profileStage"
    );


const profileCard =
    profileStage
        ?.querySelector(
            ".profile-card"
        );


if (
    profileStage &&
    profileCard &&
    !prefersReducedMotion
) {

    const isTouchDevice =
        window.matchMedia(
            "(hover: none), (pointer: coarse)"
        ).matches;


    /* --------------------------------------------------------
       DESKTOP MOUSE 3D
    --------------------------------------------------------- */

    if (!isTouchDevice) {

        profileStage
            .addEventListener(
                "mousemove",
                (event) => {

                    const rect =
                        profileStage
                            .getBoundingClientRect();


                    const x =
                        event.clientX -
                        rect.left;


                    const y =
                        event.clientY -
                        rect.top;


                    const rotateY =
                        (
                            x /
                            rect.width -
                            0.5
                        ) * 8;


                    const rotateX =
                        (
                            0.5 -
                            y /
                            rect.height
                        ) * 8;


                    profileCard
                        .style
                        .transform =
                        `
                        rotateX(${rotateX}deg)
                        rotateY(${rotateY}deg)
                        translateZ(7px)
                        `;

                }
            );


        profileStage
            .addEventListener(
                "mouseleave",
                () => {

                    profileCard
                        .style
                        .transform =
                        `
                        rotateX(0deg)
                        rotateY(0deg)
                        translateZ(0px)
                        `;

                }
            );

    }


    /* --------------------------------------------------------
       MOBILE AUTOMATIC MOTION
    --------------------------------------------------------- */

    else {

        let startTime =
            performance.now();


        let touchActive =
            false;


        function animateMobileCard(
            currentTime
        ) {

            if (!touchActive) {

                const elapsed =
                    (
                        currentTime -
                        startTime
                    ) / 1000;


                const rotateY =
                    Math.sin(
                        elapsed * 0.9
                    ) * 3.2;


                const rotateX =
                    Math.cos(
                        elapsed * 0.65
                    ) * 1.5;


                const translateY =
                    Math.sin(
                        elapsed * 1.1
                    ) * 2;


                profileCard
                    .style
                    .transform =
                    `
                    rotateX(${rotateX}deg)
                    rotateY(${rotateY}deg)
                    translateY(${translateY}px)
                    `;

            }


            requestAnimationFrame(
                animateMobileCard
            );

        }


        requestAnimationFrame(
            animateMobileCard
        );


        /* ----------------------------------------------------
           TOUCH INTERACTION
        ----------------------------------------------------- */

        profileStage
            .addEventListener(
                "touchstart",
                () => {

                    touchActive =
                        true;

                },
                {
                    passive: true
                }
            );


        profileStage
            .addEventListener(
                "touchmove",
                (event) => {

                    const touch =
                        event.touches[0];


                    if (!touch) {
                        return;
                    }


                    const rect =
                        profileStage
                            .getBoundingClientRect();


                    const relativeX =
                        (
                            touch.clientX -
                            rect.left
                        ) /
                        rect.width;


                    const relativeY =
                        (
                            touch.clientY -
                            rect.top
                        ) /
                        rect.height;


                    const rotateY =
                        (
                            relativeX -
                            0.5
                        ) * 8;


                    const rotateX =
                        (
                            0.5 -
                            relativeY
                        ) * 5;


                    profileCard
                        .style
                        .transform =
                        `
                        rotateX(${rotateX}deg)
                        rotateY(${rotateY}deg)
                        `;

                },
                {
                    passive: true
                }
            );


        profileStage
            .addEventListener(
                "touchend",
                () => {

                    touchActive =
                        false;


                    startTime =
                        performance.now();

                },
                {
                    passive: true
                }
            );

    }

}



/* ============================================================
   09. COPY EMAIL
============================================================ */

const copyEmailButton =
    document.getElementById(
        "copyEmailButton"
    );


const copyStatus =
    document.getElementById(
        "copyStatus"
    );


if (
    copyEmailButton &&
    copyStatus
) {

    copyEmailButton
        .addEventListener(
            "click",
            async () => {

                const email =
                    copyEmailButton
                        .dataset
                        .email;


                try {

                    await navigator
                        .clipboard
                        .writeText(
                            email
                        );


                    copyStatus
                        .textContent =
                        "Email copied to clipboard.";

                } catch (error) {

                    copyStatus
                        .textContent =
                        email;

                }


                window
                    .setTimeout(
                        () => {

                            copyStatus
                                .textContent =
                                "";

                        },
                        2500
                    );

            }
        );

}



/* ============================================================
   10. PROJECT DATA
============================================================ */

const projectData = {

    flagship: {

        category:
            "END-TO-END ANALYTICS",

        title:
            "Flagship End-to-End Analytics",

        description:
            "A complete analytics workflow covering raw CSV data, PostgreSQL validation and business analysis, Python/Pandas exploratory analysis, Power BI dashboarding and business recommendations.",

        image:
            "assets/projects/flagship/Images/Flagship_Analytics_Dashboard.png",

        repo:
            "https://github.com/Joelr-2026/Flagship_End_to_End_Analytics",

        metrics: [
            {
                value: "800",
                label: "Customers"
            },
            {
                value: "150",
                label: "Products"
            },
            {
                value: "3,005",
                label: "Orders"
            }
        ],

        workflow: [
            "Raw CSV",
            "PostgreSQL",
            "Data Validation",
            "SQL Analysis",
            "Python EDA",
            "Power BI",
            "Business Insights"
        ],

        highlights: [
            "Structured relational tables and validated source data before analysis.",
            "Used SQL to analyze sales, customers, products, categories and profitability.",
            "Used Python and Pandas for exploratory analysis and supporting visualizations.",
            "Built a Power BI dashboard for revenue, profit, customer and product performance.",
            "Converted analysis results into business-focused findings and recommendations."
        ],

        stack: [
            "PostgreSQL",
            "SQL",
            "Python",
            "Pandas",
            "Power BI"
        ]

    },


    inventory: {

        category:
            "SQL + POWER BI",

        title:
            "Inventory Optimization & Demand Planning",

        description:
            "A demand-planning portfolio project focused on data validation, demand behavior, data-quality investigation and Power BI reporting using more than one million demand records.",

        image:
            "assets/projects/inventory/Images/inventory_dashboard.png",

        repo:
            "https://github.com/Joelr-2026/Inventory_Optimization---Demand_Planning_project",

        metrics: [
            {
                value: "1,048,575",
                label: "Demand Records"
            },
            {
                value: "10,469",
                label: "Negative Demand"
            },
            {
                value: "11,239",
                label: "Missing Dates"
            }
        ],

        workflow: [
            "Demand Data",
            "PostgreSQL",
            "Validation",
            "Business Analysis",
            "Power BI",
            "Dashboard"
        ],

        highlights: [
            "Loaded and inspected large-volume inventory demand data.",
            "Investigated missing dates, negative demand values and duplicate-looking records.",
            "Used SQL for validation and structured business analysis.",
            "Created dashboard KPIs, trends and product-level demand views.",
            "Focused on practical demand-planning and inventory reporting questions."
        ],

        stack: [
            "PostgreSQL",
            "SQL",
            "Power BI",
            "DAX"
        ]

    },


    churn: {

        category:
            "PYTHON DATA ANALYSIS",

        title:
            "Customer Churn Analysis",

        description:
            "A Python-based customer churn project covering data inspection, cleaning, categorical churn analysis, numerical comparison, visualization and business interpretation.",

        image:
            "assets/projects/churn/Images/churn_distribution.png",

        repo:
            "https://github.com/Joelr-2026/Customer_Churn_Analysis",

        metrics: [
            {
                value: "1,500",
                label: "Customers"
            },
            {
                value: "Python",
                label: "EDA"
            },
            {
                value: "Charts",
                label: "Insights"
            }
        ],

        workflow: [
            "CSV",
            "Pandas",
            "Cleaning",
            "EDA",
            "Visualization",
            "Insights"
        ],

        highlights: [
            "Inspected customer, subscription, service and churn-related fields.",
            "Cleaned inconsistent categorical values and handled missing data.",
            "Compared churn across contract type, plan, city and signup channel.",
            "Analyzed numerical factors including complaints, support calls, payments and tenure.",
            "Created visualizations and summarized churn-related patterns."
        ],

        stack: [
            "Python",
            "Pandas",
            "NumPy",
            "Matplotlib",
            "Seaborn",
            "Jupyter"
        ]

    },


    ecommerce: {

        category:
            "POSTGRESQL PROJECT",

        title:
            "Ecommerce SQL Analysis",

        description:
            "A SQL portfolio project using ecommerce data to answer revenue, customer, product, department and time-based business questions using PostgreSQL.",

        image:
            "assets/projects/ecommerce-sql/Images/monthly_sales_trend.png",

        repo:
            "https://github.com/Joelr-2026/Ecommerce_SQL_Analysis",

        metrics: [
            {
                value: "2,505",
                label: "Records"
            },
            {
                value: "SQL",
                label: "Analysis"
            },
            {
                value: "PostgreSQL",
                label: "Database"
            }
        ],

        workflow: [
            "Raw Data",
            "PostgreSQL",
            "Validation",
            "Business Queries",
            "Advanced SQL",
            "Insights"
        ],

        highlights: [
            "Created and validated the PostgreSQL analysis table.",
            "Used filtering, grouping, CASE expressions and aggregations.",
            "Used joins, subqueries, CTEs and window functions.",
            "Analyzed sales trends, product performance and customer behavior.",
            "Produced department rankings and month-over-month analysis."
        ],

        stack: [
            "PostgreSQL",
            "SQL",
            "CTEs",
            "Subqueries",
            "Window Functions"
        ]

    },


    food: {

        category:
            "POWER BI PROJECT",

        title:
            "Food Delivery Power BI Analysis",

        description:
            "A Power BI portfolio project transforming raw food-delivery data into a cleaned analytical model, KPI reporting and an interactive dashboard.",

        image:
            "assets/projects/food-delivery/Images/food_delivery_dashboard.png",

        repo:
            "https://github.com/Joelr-2026/Food_Delivery_PowerBI_Analysis",

        metrics: [
            {
                value: "2,000",
                label: "Records"
            },
            {
                value: "Power BI",
                label: "Dashboard"
            },
            {
                value: "DAX",
                label: "KPIs"
            }
        ],

        workflow: [
            "Raw Data",
            "Power Query",
            "Cleaning",
            "Data Model",
            "DAX",
            "Dashboard"
        ],

        highlights: [
            "Cleaned and transformed delivery data using Power Query.",
            "Created analytical fields and business KPIs.",
            "Built DAX measures for reporting.",
            "Added interactive slicers and dashboard visuals.",
            "Summarized operational patterns through a recruiter-ready Power BI dashboard."
        ],

        stack: [
            "Power BI",
            "Power Query",
            "DAX",
            "Data Visualization"
        ]

    },


    retail: {

        category:
            "EXCEL ANALYTICS",

        title:
            "Retail Sales Excel Analysis",

        description:
            "An Excel portfolio project using Power Query, formulas, PivotTables, PivotCharts and slicers to analyze retail sales and build an interactive dashboard.",

        image:
            "assets/projects/retail-sales/Images/retail_sales_dashboard.png",

        repo:
            "https://github.com/Joelr-2026/Retail-Sales-Excel-Analysis",

        metrics: [
            {
                value: "1,205",
                label: "Records"
            },
            {
                value: "Excel",
                label: "Analysis"
            },
            {
                value: "Dashboard",
                label: "Output"
            }
        ],

        workflow: [
            "CSV",
            "Power Query",
            "Cleaning",
            "Excel Analysis",
            "PivotTables",
            "Dashboard"
        ],

        highlights: [
            "Prepared retail sales data for analysis.",
            "Used Excel formulas and structured analysis techniques.",
            "Built PivotTables and PivotCharts for key business questions.",
            "Added KPI cards and slicers for interactive reporting.",
            "Created a portfolio-ready retail sales dashboard."
        ],

        stack: [
            "Microsoft Excel",
            "Power Query",
            "PivotTables",
            "PivotCharts",
            "Slicers"
        ]

    }

};



/* ============================================================
   11. PROJECT MODAL ELEMENTS
============================================================ */

const projectModal =
    document.getElementById(
        "projectModal"
    );


const modalClose =
    document.getElementById(
        "modalClose"
    );


const modalImage =
    document.getElementById(
        "modalImage"
    );


const modalCategory =
    document.getElementById(
        "modalCategory"
    );


const modalTitle =
    document.getElementById(
        "modalTitle"
    );


const modalDescription =
    document.getElementById(
        "modalDescription"
    );


const modalMetrics =
    document.getElementById(
        "modalMetrics"
    );


const modalWorkflow =
    document.getElementById(
        "modalWorkflow"
    );


const modalHighlights =
    document.getElementById(
        "modalHighlights"
    );


const modalStack =
    document.getElementById(
        "modalStack"
    );


const modalGithub =
    document.getElementById(
        "modalGithub"
    );



/* ============================================================
   12. OPEN PROJECT MODAL
============================================================ */

function openProjectModal(
    projectKey
) {

    const project =
        projectData[
            projectKey
        ];


    if (
        !project ||
        !projectModal
    ) {

        return;

    }


    modalImage.src =
        project.image;


    modalImage.alt =
        `${project.title} preview`;


    modalCategory.textContent =
        project.category;


    modalTitle.textContent =
        project.title;


    modalDescription.textContent =
        project.description;


    modalMetrics.innerHTML =
        "";


    project.metrics.forEach(
        (metric) => {

            const metricElement =
                document.createElement(
                    "div"
                );


            metricElement.className =
                "modal-metric";


            const value =
                document.createElement(
                    "strong"
                );


            value.textContent =
                metric.value;


            const label =
                document.createElement(
                    "span"
                );


            label.textContent =
                metric.label;


            metricElement.append(
                value,
                label
            );


            modalMetrics
                .appendChild(
                    metricElement
                );

        }
    );


    modalWorkflow.innerHTML =
        "";


    project.workflow.forEach(
        (step) => {

            const stepElement =
                document.createElement(
                    "span"
                );


            stepElement.textContent =
                step;


            modalWorkflow
                .appendChild(
                    stepElement
                );

        }
    );


    modalHighlights.innerHTML =
        "";


    project.highlights.forEach(
        (highlight) => {

            const listItem =
                document.createElement(
                    "li"
                );


            listItem.textContent =
                highlight;


            modalHighlights
                .appendChild(
                    listItem
                );

        }
    );


    modalStack.innerHTML =
        "";


    project.stack.forEach(
        (tool) => {

            const toolElement =
                document.createElement(
                    "span"
                );


            toolElement.textContent =
                tool;


            modalStack
                .appendChild(
                    toolElement
                );

        }
    );


    modalGithub.href =
        project.repo;


    projectModal
        .classList
        .add(
            "open"
        );


    projectModal
        .setAttribute(
            "aria-hidden",
            "false"
        );


    document.body.style.overflow =
        "hidden";


    modalClose?.focus();

}



/* ============================================================
   13. CLOSE PROJECT MODAL
============================================================ */

function closeProjectModal() {

    if (!projectModal) {
        return;
    }


    projectModal
        .classList
        .remove(
            "open"
        );


    projectModal
        .setAttribute(
            "aria-hidden",
            "true"
        );


    document.body.style.overflow =
        "";

}



/* ============================================================
   14. CASE STUDY BUTTONS
============================================================ */

document
    .querySelectorAll(
        ".case-study-button"
    )
    .forEach(
        (button) => {

            button
                .addEventListener(
                    "click",
                    () => {

                        const projectKey =
                            button
                                .dataset
                                .project;


                        openProjectModal(
                            projectKey
                        );

                    }
                );

        }
    );



/* ============================================================
   15. MODAL CLOSE EVENTS
============================================================ */

modalClose
    ?.addEventListener(
        "click",
        closeProjectModal
    );


document
    .querySelectorAll(
        "[data-close-modal]"
    )
    .forEach(
        (element) => {

            element
                .addEventListener(
                    "click",
                    closeProjectModal
                );

        }
    );


document
    .addEventListener(
        "keydown",
        (event) => {

            if (
                event.key ===
                    "Escape" &&

                projectModal
                    ?.classList
                    .contains(
                        "open"
                    )
            ) {

                closeProjectModal();

            }

        }
    );



/* ============================================================
   16. CURRENT YEAR
============================================================ */

const currentYear =
    document.getElementById(
        "currentYear"
    );


if (currentYear) {

    currentYear.textContent =
        new Date()
            .getFullYear();

}