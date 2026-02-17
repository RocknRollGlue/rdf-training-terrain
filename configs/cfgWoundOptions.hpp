/*
 * Defines settings used by wound creation for medical simulation.
 */
class CfgWoundOptions
{
	class woundInfo
    {
        damageMin = 0;
        damageMax = 1;
        amountMin = 1;
        amountMax = 1;
        allowedBodyparts[] = {"head", "body", "leftarm", "rightarm", "leftleg", "rightleg"};
        allowedCauses[] = {"bullet", "grenade", "explosive", "shell", "vehiclecrash", "backblast", "collision"};
        private = 1;
    };

    class woundAccidentalBase: woundInfo
    {
        amountMin = 1;
        amountMax = 3;
        allowedCauses[] = {"vehiclecrash", "collision"};
    };

    class woundAccidentalMinor: woundAccidentalBase
    {
        private = 0;
        damageMin = 0.1;
        damageMax = 1;
        allowedBodyparts[] = {"leftarm", "rightarm", "leftleg", "rightleg"};
    };

    class woundAccidentalMedium: woundAccidentalBase
    {
        private = 0;
        damageMin = 1;
        damageMax = 2;
        allowedBodyparts[] = {"leftarm", "rightarm", "leftleg", "rightleg"};
    };

    class woundAccidentalMajor: woundAccidentalBase
    {
        private = 0;
        damageMin = 2;
        damageMax = 4;
    };

    class woundCombatBase: woundInfo
    {
        amountMin = 1;
        amountMax = 5;
        allowedCauses[] = {"bullet"};
    };

    class woundCombatMinor: woundCombatBase
    {
        private = 0;
        damageMin = 0.8;
        damageMax = 1.2;
        amountMax = 1;
    };

    class woundCombatMedium: woundCombatBase
    {
        private = 0;
        damageMin = 1;
        damageMax = 2;
        amountMax = 3;
    };

    class woundCombatMajor: woundCombatBase
    {
        private = 0;
        damageMin = 1;
        damageMax = 4;
        amountMin = 3;
        amountMax = 5;
    };

    class woundExplosionBase: woundInfo
    {
        amountMin = 1;
        amountMax = 5;
        allowedCauses[] = {"grenade", "explosive", "shell"};
    };

    class woundExplosionMinor: woundExplosionBase
    {
        private = 0;
        damageMin = 0.1;
        damageMax = 1;
        amountMax = 2;
    };

    class woundExplosionMedium: woundExplosionBase
    {
        private = 0;
        damageMin = 1;
        damageMax = 2;
    };

    class woundExplosionMajor: woundExplosionBase
    {
        private = 0;
        damageMin = 2;
        damageMax = 5;
        amountMin = 2;
    };
};